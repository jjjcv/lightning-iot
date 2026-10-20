<template>
  <section class="app-main">
    <header v-if="showPageHeading" class="page-heading">
      <div>
        <span class="page-heading__eyebrow">LIGHTNING IOT</span>
        <h1>{{ route.meta.title }}</h1>
      </div>
    </header>
    <router-view v-slot="{ Component, route }">
      <transition name="fade-transform" mode="out-in">
        <keep-alive :include="tagsViewStore.cachedViews">
          <component v-if="!route.meta.link" :is="Component" :key="route.path"/>
        </keep-alive>
      </transition>
    </router-view>
    <iframe-toggle />
    <copyright />
  </section>
</template>

<script setup lang="ts">
import copyright from "./Copyright/index.vue"
import iframeToggle from "./IframeToggle/index.vue"
import useTagsViewStore from '@/store/modules/tagsView'

const route = useRoute()
const tagsViewStore = useTagsViewStore()
const showPageHeading = computed(() =>
  Boolean(route.meta.title) && route.path !== '/index'
)

onMounted(() => {
  addIframe()
})

watchEffect(() => {
  addIframe()
})

function addIframe(): void {
  if (route.meta.link) {
    useTagsViewStore().addIframeView(route)
  }
}
</script>

<style lang="scss" scoped>
.app-main {
  /* 50= navbar  50  */
  min-height: calc(100vh - 50px);
  width: 100%;
  position: relative;
  overflow: hidden;
  background: var(--ui-page-bg);
}

.page-heading {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20px 24px 0;

  &::after {
    width: clamp(80px, 14vw, 220px);
    height: 1px;
    margin-left: auto;
    background: linear-gradient(90deg, transparent, color-mix(in srgb, var(--ui-accent-cyan) 65%, transparent));
    box-shadow: 0 0 10px color-mix(in srgb, var(--ui-accent-cyan) 30%, transparent);
    content: "";
  }

  h1 {
    margin: 2px 0 0;
    color: var(--ui-text-primary);
    font-size: 22px;
    font-weight: 650;
    line-height: 1.35;
  }
}

.page-heading__eyebrow {
  color: var(--ui-accent-cyan);
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.14em;
}

.fixed-header + .app-main {
  overflow-y: auto;
  scrollbar-gutter: auto;
  height: calc(100vh - 50px);
  min-height: 0px;
}

.app-main:has(.copyright) {
  padding-bottom: 36px;
}

.fixed-header + .app-main {
  margin-top: 50px;
}

.hasTagsView {
  .app-main {
    /* 84 = navbar + tags-view = 50 + 34 */
    min-height: calc(100vh - 84px);
  }

  .fixed-header + .app-main {
    margin-top: 84px;
    height: calc(100vh - 84px);
    min-height: 0px;
  }
}

/* 移动端fixed-header优化 */
@media screen and (max-width: 991px) {
  .page-heading {
    padding: 16px 16px 0;
  }

  .fixed-header + .app-main {
    padding-bottom: max(60px, calc(constant(safe-area-inset-bottom) + 40px));
    padding-bottom: max(60px, calc(env(safe-area-inset-bottom) + 40px));
    overscroll-behavior-y: none;
  }

  .hasTagsView .fixed-header + .app-main {
    padding-bottom: max(60px, calc(constant(safe-area-inset-bottom) + 40px));
    padding-bottom: max(60px, calc(env(safe-area-inset-bottom) + 40px));
    overscroll-behavior-y: none;
  }
}

@media screen and (max-width: 640px) {
  .page-heading {
    padding: 14px 12px 0;

    h1 {
      font-size: 19px;
    }
  }
}

@supports (-webkit-touch-callout: none) {
  @media screen and (max-width: 991px) {
    .fixed-header + .app-main {
      padding-bottom: max(17px, calc(constant(safe-area-inset-bottom) + 10px));
      padding-bottom: max(17px, calc(env(safe-area-inset-bottom) + 10px));
      height: calc(100svh - 50px);
      height: calc(100dvh - 50px);
    }

    .hasTagsView .fixed-header + .app-main {
      padding-bottom: max(17px, calc(constant(safe-area-inset-bottom) + 10px));
      padding-bottom: max(17px, calc(env(safe-area-inset-bottom) + 10px));
      height: calc(100svh - 84px);
      height: calc(100dvh - 84px);
    }
  }
}
</style>

<style lang="scss">
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background-color: transparent;
}

::-webkit-scrollbar-thumb {
  background-color: color-mix(in srgb, var(--ui-text-placeholder) 55%, transparent);
  border: 2px solid transparent;
  border-radius: 999px;
  background-clip: content-box;
}

::-webkit-scrollbar-thumb:hover {
  background-color: color-mix(in srgb, var(--ui-text-secondary) 70%, transparent);
  background-clip: content-box;
}
</style>
