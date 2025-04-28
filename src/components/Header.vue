<script setup lang="ts">
  import BurgerMenu from './BurgerMenu.vue';
</script>

<template>
  <div class="header default-shadow">
    <h1 class="title">Not the End</h1>

    <div class="burger-menu-container">
      <BurgerMenu></BurgerMenu>
    </div>
  </div>
</template>

<style scoped>
  .header {
    display: flex;
    flex-direction: row;
    justify-content: space-between;

    padding: 8px 16px;
    padding-right: 12px;
  }

  .title {
    font-size: 1.5em;
    font-weight: 500;
  }

  .burger-menu-container {
    padding-top: 6px;
  }
</style>
