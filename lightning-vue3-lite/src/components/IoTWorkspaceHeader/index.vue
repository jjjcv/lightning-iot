<template>
  <section class="iot-workspace-header">
    <div class="iot-workspace-header__main">
      <div class="iot-workspace-header__identity">
        <span class="iot-workspace-header__icon">
          <slot name="icon" />
        </span>
        <div>
          <span class="iot-workspace-header__eyebrow">{{ eyebrow }}</span>
          <h1>{{ title }}</h1>
          <p>{{ description }}</p>
        </div>
      </div>
      <div v-if="$slots.actions" class="iot-workspace-header__actions">
        <slot name="actions" />
      </div>
    </div>

    <div class="iot-workspace-header__stats">
      <article
        v-for="item in stats"
        :key="item.label"
        class="iot-workspace-header__stat"
        :class="item.tone ? `is-${item.tone}` : ''"
      >
        <span class="iot-workspace-header__stat-icon">
          <el-icon><component :is="item.icon || 'DataLine'" /></el-icon>
        </span>
        <div>
          <span>{{ item.label }}</span>
          <strong>{{ item.value }}</strong>
          <small v-if="item.hint">{{ item.hint }}</small>
        </div>
      </article>
    </div>
  </section>
</template>

<script setup>
defineProps({
  eyebrow: {
    type: String,
    default: "IOT ASSET CENTER",
  },
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    default: "",
  },
  stats: {
    type: Array,
    default: () => [],
  },
});
</script>

<style scoped lang="scss">
.iot-workspace-header {
  position: relative;
  margin-bottom: 18px;
  padding: 26px;
  overflow: hidden;
  color: #fff;
  background:
    radial-gradient(circle at 88% -30%, rgba(99, 226, 255, 0.38), transparent 38%),
    linear-gradient(125deg, #102a5c 0%, #164ba0 56%, #087e99 100%);
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 16px;
  box-shadow: 0 18px 42px rgba(17, 48, 98, 0.18);

  &::after {
    position: absolute;
    right: -52px;
    bottom: -110px;
    width: 280px;
    height: 280px;
    border: 1px solid rgba(255, 255, 255, 0.12);
    border-radius: 50%;
    box-shadow:
      0 0 0 32px rgba(255, 255, 255, 0.035),
      0 0 0 68px rgba(255, 255, 255, 0.025);
    content: "";
  }
}

.iot-workspace-header__main {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 24px;
}

.iot-workspace-header__identity {
  display: flex;
  align-items: center;
  gap: 16px;
  min-width: 0;
}

.iot-workspace-header__icon {
  display: grid;
  flex: 0 0 52px;
  width: 52px;
  height: 52px;
  place-items: center;
  font-size: 26px;
  background: rgba(255, 255, 255, 0.13);
  border: 1px solid rgba(255, 255, 255, 0.22);
  border-radius: 14px;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.14);
  backdrop-filter: blur(8px);
}

.iot-workspace-header__eyebrow {
  display: block;
  margin-bottom: 4px;
  color: rgba(209, 240, 255, 0.8);
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.16em;
}

h1 {
  margin: 0;
  color: #fff;
  font-size: clamp(24px, 2vw, 31px);
  line-height: 1.24;
}

p {
  max-width: 720px;
  margin: 7px 0 0;
  color: rgba(233, 246, 255, 0.82);
  font-size: 14px;
  line-height: 1.6;
}

.iot-workspace-header__actions {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-end;
  gap: 10px;

  :deep(.el-button) {
    min-height: 40px;
    margin-left: 0;
    border-color: rgba(255, 255, 255, 0.35);
  }

  :deep(.el-button:not(.el-button--primary)) {
    color: #fff;
    background: rgba(255, 255, 255, 0.1);
  }
}

.iot-workspace-header__stats {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
  margin-top: 24px;
}

.iot-workspace-header__stat {
  display: flex;
  align-items: center;
  gap: 12px;
  min-width: 0;
  padding: 13px 15px;
  background: rgba(8, 29, 68, 0.34);
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 12px;
  backdrop-filter: blur(8px);
}

.iot-workspace-header__stat-icon {
  display: grid;
  flex: 0 0 34px;
  width: 34px;
  height: 34px;
  place-items: center;
  color: #8ee9ff;
  font-size: 18px;
  background: rgba(65, 209, 243, 0.12);
  border-radius: 9px;
}

.iot-workspace-header__stat > div {
  display: grid;
  min-width: 0;
  grid-template-columns: auto auto;
  align-items: baseline;
  gap: 2px 8px;
}

.iot-workspace-header__stat span:not(.iot-workspace-header__stat-icon) {
  color: rgba(229, 243, 255, 0.72);
  font-size: 12px;
}

.iot-workspace-header__stat strong {
  grid-row: span 2;
  color: #fff;
  font-size: 24px;
  line-height: 1;
}

.iot-workspace-header__stat small {
  max-width: 130px;
  overflow: hidden;
  color: rgba(229, 243, 255, 0.52);
  font-size: 11px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.iot-workspace-header__stat.is-success .iot-workspace-header__stat-icon {
  color: #6ff0bc;
  background: rgba(54, 211, 153, 0.13);
}

.iot-workspace-header__stat.is-warning .iot-workspace-header__stat-icon {
  color: #ffd27a;
  background: rgba(255, 188, 64, 0.14);
}

.iot-workspace-header__stat.is-danger .iot-workspace-header__stat-icon {
  color: #ff9eaa;
  background: rgba(255, 97, 121, 0.13);
}

@media (max-width: 1100px) {
  .iot-workspace-header__stats {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 720px) {
  .iot-workspace-header {
    padding: 20px;
  }

  .iot-workspace-header__main,
  .iot-workspace-header__identity {
    align-items: flex-start;
  }

  .iot-workspace-header__main {
    flex-direction: column;
  }

  .iot-workspace-header__actions {
    width: 100%;
    justify-content: flex-start;
  }

  .iot-workspace-header__stats {
    grid-template-columns: 1fr;
  }
}
</style>
