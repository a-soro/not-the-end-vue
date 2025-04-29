<script setup lang="ts">
  import { ref, type Ref } from 'vue';
  import pkg from '../../package.json';
  import { useLocalStorage } from '@vueuse/core';

  const appVersion = pkg.version;

  const isActive: Ref<boolean, boolean> = ref(false);

  const maxTokens = useLocalStorage('NtE__maxTokens', 4, { mergeDefaults: true });

  function burgerClick() {
    isActive.value = !isActive.value;
  }
</script>

<template>
  <div :class="{'burger-menu': true, 'active': isActive}" @click="burgerClick">
    <div class="burger-container">
      <div class="burger-inner"></div>
    </div>
  </div>

  <div :class="{'overlay': true, 'open': isActive}"></div>

  <div :class="{'side-menu': true, 'open': isActive}">
    <div class="options">
      <p><b>Opzioni</b></p>

      <div class="option">
        <label for="maxTokensInput" style="margin-right: 12px;">Max tokens: </label>
        <input type="number" id="maxTokensInput" placeholder="es: 4" min="4" max="10" v-model.number="maxTokens" />
      </div>
    </div>

    <div class="info">
      <p>
        <b>"Not the End"</b> è un gioco di ruolo creato da Claudio Pustorino ed edito da Fumble GdR; puoi trovarlo al link:
        <a href="https://www.fumblegdr.it/products/not-the-end-manuale-base" target="_blank">
          https://www.fumblegdr.it/products/not-the-end-manuale-base
        </a>
      </p>
      <p class="app-version">v{{ appVersion }}</p>
    </div>
  </div>
</template>

<style scoped>
  .overlay.open {
    position: fixed;
    top: 50px;
    bottom: 0;
    left: 0;
    right: 0;

    background-color: rgba(0, 0, 0, 0.7);
  }

  .side-menu {
    display: flex;
    flex-direction: column;
    justify-content: space-between;

    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    width: calc(100lvw - 50px);
    max-width: 400px;

    padding: 20px;

    background-color: #181818;

    transition: transform 250ms linear;
    transform: translate3d(-100lvw, 0, 0);


    -webkit-box-shadow: 15px 0px 15px -15px rgba(0,0,0,0.75);
    -moz-box-shadow: 15px 0px 15px -15px rgba(0,0,0,0.75);
    box-shadow: 15px 0px 15px -15px rgba(0,0,0,0.75);
  }

  .side-menu.open {
    transform: translate3d(0, 0, 0);
  }

  .side-menu a {
    color: aliceblue;
  }

  .side-menu .app-version {
    text-align: right;
    margin-top: 12px;
  }

  .side-menu .options .option {
    margin-left: 20px;
  }

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
