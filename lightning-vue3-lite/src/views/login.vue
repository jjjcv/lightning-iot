<template>
  <div class="login">
    <div class="tech-grid" aria-hidden="true"></div>

    <main class="login-shell">
      <section class="login-intro">
        <div class="brand-lockup">
          <img :src="logo" alt="Lightning" />
          <div>
            <strong>LIGHTNING</strong>
            <span>LIGHTNING IOT COMMUNITY</span>
          </div>
        </div>

        <div class="hero-copy">
          <div class="hero-eyebrow"><i></i> INTELLIGENT IOT PLATFORM</div>
          <h1>让每一次能源流动<br /><em>都清晰可见</em></h1>
          <p>连接设备、边缘网关与能源数据，以实时洞察驱动更安全、更高效的数字化运营。</p>

          <div class="capability-list">
            <div class="capability-item">
              <span class="capability-index">01</span>
              <div><strong>全域感知</strong><small>设备状态实时监测</small></div>
            </div>
            <div class="capability-item">
              <span class="capability-index">02</span>
              <div><strong>智能协同</strong><small>边云一体高效联动</small></div>
            </div>
            <div class="capability-item">
              <span class="capability-index">03</span>
              <div><strong>安全可控</strong><small>关键数据稳定守护</small></div>
            </div>
          </div>
        </div>

        <div class="system-pulse"><span></span> SYSTEM ONLINE · SECURE CONNECTION</div>
      </section>

      <section class="login-panel-wrap">
        <el-form ref="loginRef" :model="loginForm" :rules="loginRules" class="login-form">
          <div class="access-badge"><span></span> SECURE ACCESS</div>
          <h2 class="title">{{ title }}</h2>
          <p class="login-subtitle">欢迎回来，请使用您的平台账号继续</p>

          <el-form-item prop="username">
            <el-input
              v-model="loginForm.username"
              type="text"
              size="large"
              auto-complete="off"
              placeholder="账号"
            >
              <template #prefix><svg-icon icon-class="user" class="el-input__icon input-icon" /></template>
            </el-input>
          </el-form-item>
          <el-form-item prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              size="large"
              auto-complete="off"
              placeholder="密码"
              @keyup.enter="handleLogin"
            >
              <template #prefix><svg-icon icon-class="password" class="el-input__icon input-icon" /></template>
            </el-input>
          </el-form-item>
          <el-form-item prop="code" v-if="captchaEnabled" class="captcha-item">
            <el-input
              v-model="loginForm.code"
              size="large"
              auto-complete="off"
              placeholder="验证码"
              class="code-input"
              @keyup.enter="handleLogin"
            >
              <template #prefix><svg-icon icon-class="validCode" class="el-input__icon input-icon" /></template>
            </el-input>
            <div class="login-code">
              <img :src="codeUrl" @click="getCode" class="login-code-img" alt="验证码" />
            </div>
          </el-form-item>

          <div class="login-options">
            <el-checkbox v-model="loginForm.rememberMe">记住密码</el-checkbox>
            <span class="security-hint"><i></i> 数据加密传输</span>
          </div>

          <el-form-item class="submit-item">
            <el-button
              :loading="loading"
              size="large"
              type="primary"
              class="login-button"
              @click.prevent="handleLogin"
            >
              <span v-if="!loading">进入控制中心</span>
              <span v-else>安全验证中...</span>
            </el-button>
            <div class="register-link" v-if="register">
              <router-link class="link-type" :to="'/register'">立即注册</router-link>
            </div>
          </el-form-item>

          <div class="panel-foot">LIGHTNING DIGITAL OPERATIONS CENTER</div>
        </el-form>
      </section>
    </main>

    <div class="el-login-footer">
      <span>{{ footerContent }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { getCodeImg } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from "@/utils/jsencrypt"
import useUserStore from '@/store/modules/user'
import defaultSettings from '@/settings'
import type { LoginForm } from '@/types/api/login'
import logo from '@/assets/logo/logo.png'

const title = import.meta.env.VITE_APP_TITLE
const footerContent = defaultSettings.footerContent
const userStore = useUserStore()
const route = useRoute()
const router = useRouter()
const { proxy } = getCurrentInstance()

const loginForm = ref<LoginForm>({
  username: "admin",
  password: "admin123",
  rememberMe: false,
  code: "",
  uuid: ""
})

const loginRules = {
  username: [{ required: true, trigger: "blur", message: "请输入您的账号" }],
  password: [{ required: true, trigger: "blur", message: "请输入您的密码" }],
  code: [{ required: true, trigger: "change", message: "请输入验证码" }]
}

const codeUrl = ref("")
const loading = ref(false)
// 验证码开关
const captchaEnabled = ref(true)
// 注册开关
const register = ref(false)
const redirect = ref<string | undefined>(undefined)

watch(route, (newRoute: any) => {
    redirect.value = (newRoute.query && newRoute.query.redirect) as string | undefined
}, { immediate: true })

function handleLogin(): void {
  proxy.$refs.loginRef.validate((valid: boolean) => {
    if (valid) {
      loading.value = true
      // 勾选了需要记住密码设置在 cookie 中设置记住用户名和密码
      if (loginForm.value.rememberMe) {
        Cookies.set("username", loginForm.value.username, { expires: 30 })
        Cookies.set("password", encrypt(loginForm.value.password), { expires: 30 })
        Cookies.set("rememberMe", loginForm.value.rememberMe, { expires: 30 })
      } else {
        // 否则移除
        Cookies.remove("username")
        Cookies.remove("password")
        Cookies.remove("rememberMe")
      }
      // 调用action的登录方法
      userStore.login(loginForm.value).then(() => {
        const query = route.query
        const otherQueryParams = Object.keys(query).reduce((acc: Record<string, any>, cur) => {
          if (cur !== "redirect") {
            acc[cur] = query[cur]
          }
          return acc
        }, {})
        router.push({ path: redirect.value || "/", query: otherQueryParams })
      }).catch(() => {
        loading.value = false
        // 重新获取验证码
        if (captchaEnabled.value) {
          getCode()
        }
      })
    }
  })
}

function getCode(): void {
  getCodeImg().then(res => {
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled
    if (captchaEnabled.value) {
      codeUrl.value = "data:image/gif;base64," + res.img
      loginForm.value.uuid = res.uuid
    }
  })
}

function getCookie(): void {
  const username = Cookies.get("username")
  const password = Cookies.get("password")
  const rememberMe = Cookies.get("rememberMe")
  loginForm.value = {
    username: username === undefined ? loginForm.value.username : username,
    password: password === undefined ? loginForm.value.password : decrypt(password),
    rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
  }
}

getCode()
getCookie()
</script>

<style lang='scss' scoped>
.login {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 680px;
  height: 100%;
  overflow: hidden;
  background:
    linear-gradient(90deg, rgba(2, 8, 23, 0.08) 0%, rgba(2, 8, 23, 0.12) 52%, rgba(2, 8, 23, 0.5) 100%),
    url("../assets/images/login-technology-bg.png") center center / cover no-repeat;

  &::before {
    position: absolute;
    inset: 0;
    background: linear-gradient(180deg, rgba(3, 10, 25, 0.08) 0%, rgba(3, 10, 25, 0.12) 60%, rgba(3, 10, 25, 0.66) 100%);
    content: "";
    pointer-events: none;
  }
}

.tech-grid {
  position: absolute;
  inset: 0;
  opacity: 0.16;
  background-image:
    linear-gradient(rgba(34, 211, 238, 0.08) 1px, transparent 1px),
    linear-gradient(90deg, rgba(34, 211, 238, 0.08) 1px, transparent 1px);
  background-size: 64px 64px;
  mask-image: linear-gradient(to right, black, transparent 75%);
  pointer-events: none;
}

.login-shell {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: minmax(0, 1fr) 460px;
  gap: clamp(40px, 8vw, 130px);
  align-items: center;
  width: min(1440px, calc(100% - 96px));
  min-height: calc(100% - 120px);
  padding: 40px 0 64px;
}

.login-intro {
  align-self: stretch;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
  padding: 8px 0 16px;
  color: #fff;
}

.brand-lockup {
  display: flex;
  align-items: center;
  gap: 13px;

  img {
    width: 42px;
    height: 42px;
    border-radius: 11px;
    box-shadow: 0 0 24px rgba(34, 211, 238, 0.3);
  }

  div {
    display: flex;
    flex-direction: column;
  }

  strong {
    font-size: 17px;
    font-weight: 700;
    letter-spacing: 0.16em;
  }

  span {
    margin-top: 2px;
    color: rgba(186, 230, 253, 0.7);
    font-size: 9px;
    letter-spacing: 0.24em;
  }
}

.hero-copy {
  max-width: 720px;
  padding: 40px 0;

  h1 {
    margin: 18px 0 20px;
    color: #f8fbff;
    font-size: clamp(40px, 4.25vw, 68px);
    font-weight: 650;
    line-height: 1.18;
    letter-spacing: -0.04em;
    text-shadow: 0 10px 32px rgba(0, 0, 0, 0.38);

    em {
      color: #67e8f9;
      font-style: normal;
      text-shadow: 0 0 28px rgba(34, 211, 238, 0.35);
    }
  }

  > p {
    max-width: 620px;
    margin: 0;
    color: rgba(219, 234, 254, 0.78);
    font-size: 16px;
    line-height: 1.85;
  }
}

.hero-eyebrow,
.system-pulse {
  display: flex;
  align-items: center;
  gap: 9px;
  color: #7dd3fc;
  font-size: 10px;
  font-weight: 650;
  letter-spacing: 0.2em;

  i,
  span {
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: #22d3ee;
    box-shadow: 0 0 14px #22d3ee;
  }
}

.capability-list {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
  margin-top: 38px;
}

.capability-item {
  display: flex;
  align-items: center;
  gap: 12px;
  min-width: 0;
  padding: 13px 14px;
  background: rgba(5, 20, 41, 0.48);
  border: 1px solid rgba(125, 211, 252, 0.18);
  border-radius: 10px;
  backdrop-filter: blur(12px);

  > div {
    display: flex;
    flex-direction: column;
    min-width: 0;
  }

  strong {
    color: #f0f9ff;
    font-size: 13px;
    font-weight: 600;
  }

  small {
    margin-top: 3px;
    overflow: hidden;
    color: rgba(186, 230, 253, 0.56);
    font-size: 10px;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.capability-index {
  color: #22d3ee;
  font-family: Consolas, monospace;
  font-size: 11px;
}

.system-pulse {
  color: rgba(186, 230, 253, 0.55);
  font-family: Consolas, monospace;
  letter-spacing: 0.12em;

  span {
    animation: statusPulse 2s ease-in-out infinite;
  }
}

.login-panel-wrap {
  display: flex;
  justify-content: flex-end;
}

.title {
  margin: 12px 0 8px;
  color: #f8fafc;
  font-size: 26px;
  font-weight: 650;
  letter-spacing: -0.02em;
}

.login-form {
  position: relative;
  width: 460px;
  padding: 40px 40px 30px;
  overflow: hidden;
  background: linear-gradient(155deg, rgba(9, 23, 43, 0.91), rgba(4, 14, 31, 0.82));
  border: 1px solid rgba(125, 211, 252, 0.2);
  border-radius: 20px;
  box-shadow: 0 30px 80px rgba(0, 0, 0, 0.42), inset 0 1px 0 rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(24px) saturate(125%);

  &::before {
    position: absolute;
    inset: 0 0 auto;
    height: 2px;
    background: linear-gradient(90deg, transparent, #22d3ee 48%, transparent);
    content: "";
  }

  :deep(.el-form-item) {
    margin-bottom: 20px;
  }

  :deep(.el-input__wrapper) {
    min-height: 50px;
    padding: 1px 15px;
    background: rgba(5, 18, 36, 0.72);
    border: 1px solid rgba(125, 211, 252, 0.12);
    border-radius: 10px;
    box-shadow: none;
  }

  :deep(.el-input__wrapper:hover) {
    border-color: rgba(34, 211, 238, 0.38);
  }

  :deep(.el-input__wrapper.is-focus) {
    border-color: #22d3ee;
    box-shadow: 0 0 0 3px rgba(34, 211, 238, 0.12) !important;
  }

  :deep(.el-input__inner) {
    color: #eaf6ff;
    font-size: 14px;

    &::placeholder {
      color: rgba(186, 230, 253, 0.42);
    }
  }

  :deep(.el-input__prefix) {
    color: #67e8f9;
  }

  .input-icon {
    width: 16px;
    height: 16px;
  }
}

.access-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: #67e8f9;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.17em;

  span {
    width: 22px;
    height: 1px;
    background: #22d3ee;
    box-shadow: 0 0 8px #22d3ee;
  }
}

.login-subtitle {
  margin: 0 0 28px;
  color: rgba(186, 230, 253, 0.58);
  font-size: 13px;
}

.captcha-item {
  :deep(.el-form-item__content) {
    display: flex;
    flex-wrap: nowrap;
    gap: 10px;
  }
}

.code-input {
  flex: 1;
  min-width: 0;
}

.login-code {
  flex: 0 0 116px;
  height: 50px;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid rgba(125, 211, 252, 0.18);
  border-radius: 10px;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    cursor: pointer;
  }
}

.login-options {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: -2px 0 22px;

  :deep(.el-checkbox__label) {
    color: rgba(219, 234, 254, 0.68);
    font-size: 13px;
  }
}

.security-hint {
  display: flex;
  align-items: center;
  gap: 6px;
  color: rgba(134, 239, 172, 0.66);
  font-size: 11px;

  i {
    width: 5px;
    height: 5px;
    border-radius: 50%;
    background: #4ade80;
    box-shadow: 0 0 8px #4ade80;
  }
}

.submit-item {
  margin-bottom: 0 !important;
}

.login-button {
  width: 100%;
  height: 50px;
  color: #effcff;
  font-size: 14px;
  font-weight: 600;
  letter-spacing: 0.08em;
  background: linear-gradient(100deg, #2563eb, #0891b2);
  border: 0;
  border-radius: 10px;
  box-shadow: 0 10px 28px rgba(8, 145, 178, 0.28);

  &:hover {
    background: linear-gradient(100deg, #3b82f6, #06b6d4);
    box-shadow: 0 14px 34px rgba(8, 145, 178, 0.36);
  }
}

.register-link {
  width: 100%;
  margin-top: 14px;
  text-align: right;
}

.panel-foot {
  margin-top: 26px;
  padding-top: 18px;
  color: rgba(125, 211, 252, 0.32);
  font-family: Consolas, monospace;
  font-size: 9px;
  text-align: center;
  letter-spacing: 0.15em;
  border-top: 1px solid rgba(125, 211, 252, 0.1);
}

.el-login-footer {
  position: absolute;
  z-index: 2;
  bottom: 14px;
  width: 100%;
  color: rgba(186, 230, 253, 0.38);
  font-size: 10px;
  text-align: center;
  letter-spacing: 0.08em;
}

.login-code-img {
  display: block;
}

@keyframes statusPulse {
  0%, 100% { opacity: 0.45; transform: scale(0.85); }
  50% { opacity: 1; transform: scale(1.1); }
}

@media (max-width: 1100px) {
  .login-shell {
    grid-template-columns: minmax(0, 1fr) 430px;
    gap: 48px;
    width: min(1080px, calc(100% - 48px));
  }

  .capability-list {
    grid-template-columns: 1fr;
    max-width: 300px;
  }

  .capability-item:nth-child(n + 3) {
    display: none;
  }
}

@media (max-width: 820px) {
  .login {
    min-height: 620px;
    background-position: 42% center;
  }

  .login-shell {
    display: flex;
    justify-content: center;
    width: calc(100% - 32px);
    padding: 28px 0 56px;
  }

  .login-intro {
    display: none;
  }

  .login-panel-wrap,
  .login-form {
    width: min(100%, 440px);
  }
}

@media (max-width: 520px) {
  .login {
    align-items: flex-start;
    min-height: 100%;
    overflow-y: auto;
  }

  .login-shell {
    width: calc(100% - 24px);
    min-height: auto;
    padding-top: 32px;
  }

  .login-form {
    padding: 30px 22px 24px;
    border-radius: 16px;
  }

  .title {
    font-size: 23px;
  }

  .el-login-footer {
    position: fixed;
  }
}
</style>
