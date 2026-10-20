<template>
  <div class="tag-select">
    <el-select
      :model-value="modelValue || []"
      multiple filterable clearable collapse-tags collapse-tags-tooltip :multiple-limit="100"
      :placeholder="placeholder" :loading="loading" style="width: 100%"
      @update:model-value="$emit('update:modelValue', $event)"
      @visible-change="visible => visible && loadOptions()"
    >
      <el-option v-for="tag in options" :key="tag.tagId" :label="tag.tagName" :value="tag.tagId" />
    </el-select>
    <el-text v-if="loadFailed" type="danger" size="small">标签加载失败，请重新展开选择框重试</el-text>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { listTagOptions } from '@/api/iot/tagDetail';

defineProps({
  modelValue: { type: Array, default: () => [] },
  placeholder: { type: String, default: '请选择标签（选填）' },
});
defineEmits(['update:modelValue']);
const options = ref([]);
const loading = ref(false);
const loadFailed = ref(false);
async function loadOptions() {
  if (loading.value) return;
  loading.value = true;
  loadFailed.value = false;
  try {
    const response = await listTagOptions();
    options.value = response.data || [];
  } catch {
    loadFailed.value = true;
  } finally {
    loading.value = false;
  }
}
onMounted(loadOptions);
</script>

<style scoped>
.tag-select { width: 100%; }
</style>
