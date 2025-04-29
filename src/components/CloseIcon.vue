<script setup lang="ts">

</script>

<template>
  <div :class="{'burger-menu': true, 'active': true}">
    <div class="burger-container">
      <div class="burger-inner"></div>
    </div>
  </div>
</template>

<style scoped>
  /** styles and animations from https://stackblitz.com/edit/angular-burger-menu */

  .burger-menu {
    width: 24px;
    height: 24px;
    cursor: pointer;
  }

  .burger-container {
    position: relative;
  }

  .burger-inner {
    position: absolute;
    width: 22px;
    left: 0px;
    top: 11px;
    border: 1px solid #c0c0c0;
    transition: border-color .2s ease-in .2s;
  }

  .burger-inner::before {
    position: absolute;
    content: '';
    top: -6px;
    left: -1px;
    width: 22px;
    border: 1px solid #c0c0c0;
    transition: top .2s ease-in .3s, transform ease-in .2s;
  }

  .burger-inner::after {
    position: absolute;
    content: '';
    top: 4px;
    left: -1px;
    width: 22px;
    border: 1px solid #c0c0c0;
    transition: top .2s ease-in .3s, transform ease-in .2s;
  }


  .burger-menu.active .burger-container .burger-inner {
    border-color: transparent;
    transition: border-color ease-in .1s;
  }

  .burger-menu.active .burger-container .burger-inner::before {
    top: -1px;
    transform: rotate(-45deg);
    transition: top ease-out .2s, transform .2s ease-out .3s;
  }

  .burger-menu.active .burger-container .burger-inner::after {
    top: -1px;
    transform: rotate(45deg);
    transition: top ease-out .2s, transform .2s ease-out .3s;
  }
</style>
