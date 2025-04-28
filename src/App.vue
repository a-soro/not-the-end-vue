<script setup lang="ts">
  import { ref, type Ref } from 'vue';
  import Header from './components/Header.vue';

  enum NtETokenType {
    Positive = 1,
    Negative = 0
  }

  const minValue: number = 1;
  const maxValue: number = 50;
  const _maxDrawableTokens: number = 4;

  const isAdrenalinChecked: Ref<boolean, boolean> = ref(false);
  const isConfusionChecked: Ref<boolean, boolean> = ref(false);

  const posValue: Ref<number, number> = ref(0);
  const negValue: Ref<number, number> = ref(0);

  const tokensToDraw: Ref<number, number> = ref(1);

  function tokTot() {
    return posValue.value + negValue.value;
  }

  function forceFocus(event: any) {
    event.target?.select();
  }

  function maxDrawableTokens() {
    return Math.min(tokTot(), _maxDrawableTokens);
  }

  function incrTokensToDraw() {
    if (!posValue.value || !negValue.value) return;
    // if (tokensToDraw == (appOptions.maxTokens)) return;
    if (tokensToDraw.value < tokTot()) {
      tokensToDraw.value++;
    }

    // console.log(tokensToDraw.value);
  }

  function decrTokensToDraw() {
    tokensToDraw.value--;
    if (tokensToDraw.value < minValue) {
      tokensToDraw.value = minValue;
    }

    // console.log(tokensToDraw.value);
  }

  function drawTokens() {
    console.log(isAdrenalinChecked.value, isConfusionChecked.value, "drawTokens", posValue.value, negValue.value);
    console.log(tokensToDraw.value);
  }
</script>

<template>
  <header>
    <Header></Header>
  </header>

  <main>
    <div class="top">
      <div class="status-list">
        <div class="status-selection">
          <input type="checkbox" id="adrenalinCheckbox" v-model="isAdrenalinChecked" />
          <label for="adrenalinCheckbox"><b>Adrenalina</b></label>
        </div>

        <div class="status-list--spacer"></div>

        <div class="status-selection">
          <input type="checkbox" id="confusionCheckbox" v-model="isConfusionChecked" />
          <label for="confusionCheckbox"><b>Confusione</b></label>
        </div>
      </div>
      
      <div class="token-selection">
        <p>Token
          <b v-if="isConfusionChecked" class="rnd-tokens">Casuali</b>
          <b v-else class="pos-tokens">Positivi</b>
        </p>
        <input v-model.number="posValue" type="number" id="posValueInput" placeholder="es: 1" min="{{minValue}}" max="{{maxValue}}" @focus="forceFocus($event)" />
      </div>
      
      <div class="token-selection">
        <p>Token <b class="neg-tokens">Negativi</b></p>
        <input v-model.number="negValue" type="number" id="negValueInput" placeholder="es: 1" min="{{minValue}}" max="{{maxValue}}" @focus="forceFocus($event)" />
      </div>
    </div>

    <div class="middle">
      <button type="button" class="edit-tokens-to-draw" @click="incrTokensToDraw" :disabled="tokensToDraw >= tokTot()">+</button>

      <p v-if="isAdrenalinChecked && tokTot()" class="tokens-to-draw with-adrenalin">{{ maxDrawableTokens() }}</p>
      <p v-else-if="tokTot()" class="tokens-to-draw">{{ tokensToDraw }}</p>
      <p v-else class="no-tokens-to-draw">Aggiungi dei token</p>

      <button type="button" class="edit-tokens-to-draw" @click="decrTokensToDraw" :disabled="tokensToDraw <= minValue || tokensToDraw == 1">-</button>
    </div>

    <div class="bottom">
      <button type="button" class="draw-tokens" @click="drawTokens" :disabled="tokensToDraw < minValue || !posValue || !negValue">estrai</button>
    </div>
  </main>
</template>

<style scoped>
  header {
    height: 52px;
  }

  main {
    margin: 0 auto;
    padding-top: 20px;
    height: calc(100lvh - 52px);
    max-width: 600px;
    width: 100lvw;

    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;
  }

  .top,
  .bottom {
    width: 100%;
  }

  .status-list,
  .token-selection {
    display: flex;
    flex-direction: row;
    justify-content: space-between;

    width: 100%;    
    padding: 8px 16px;
  }

  .status-selection {
    display: flex;
    flex-direction: row;

    width: 100%;
    margin-bottom: 20px;
  }

  .status-selection label {
    margin-left: 10px;
    margin-top: auto;
    margin-bottom: auto;
  }

  .status-list--spacer {
    width: 25%;
    min-width: 40px;
  }

  .token-selection p,
  .status-selection p {
    margin-top: auto;
    margin-bottom: auto;
  }

  .middle {
    display: flex;
    flex-direction: column;
    align-items: center;

    width: fit-content;
    min-width: 100px;
    margin-left: auto;
    margin-right: auto;
  }

  .tokens-to-draw {
    font-size: 4em;
    text-align: center;

    &.with-adrenalin {
      color: red;
    }
  }

  .no-tokens-to-draw {
    height: 96px;
    line-height: 90px;
    font-size: 1.2em;
    text-align: center;
  }

  .edit-tokens-to-draw {
    font-size: 1.2em;
    width: 40px;
  }

  button.draw-tokens {
    width: 100%;
    height: 40px;

    font-weight: bold;
    text-transform: uppercase;
    font-size: 1em;
    letter-spacing: 0.1em;
  }
</style>
