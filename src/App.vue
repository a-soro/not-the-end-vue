<script setup lang="ts">
  import { ref, type Ref } from 'vue';
  import { useLocalStorage } from '@vueuse/core';
  import Header from './components/Header.vue';
  import DrawTokensModal from './components/DrawTokensModal.vue';

  enum NtETokenType {
    Positive = 1,
    Negative = 0
  }

  const minValue: number = 1;
  const maxValue: number = 50;
  const _maxDrawableTokens = useLocalStorage('NtE__maxTokens', 4, { mergeDefaults: true });

  const isAdrenalinChecked: Ref<boolean, boolean> = ref(false);
  const isConfusionChecked: Ref<boolean, boolean> = ref(false);

  const posValue: Ref<number | undefined, number | undefined> = ref(undefined);
  const negValue: Ref<number | undefined, number | undefined> = ref(undefined);

  const tokensToDraw: Ref<number, number> = ref(1);

  const isModalOpen: Ref<boolean, boolean> = ref(false);

  function tokTot() {
    return (posValue?.value ?? 0) + (negValue?.value ?? 0);
  }

  function forceFocus(event: any) {
    event.target?.select();
  }

  function maxDrawableTokens(): number {
    return Math.min(tokTot(), _maxDrawableTokens.value);
  }

  function incrTokensToDraw() {
    // console.log(maxDrawableTokens());
    if (!posValue?.value || !negValue?.value) return;
    if (tokensToDraw.value == _maxDrawableTokens.value) return;
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

  const collection: NtETokenType[] = [];
  function drawTokens() {
    updateTokens();

    isModalOpen.value = true;
  }

  function updateTokens() {
    /** Clear collection */
    collection.splice(0, collection.length);

    /** Update collection */
    for (let i = 0; i < (posValue?.value ?? 0); i++) collection.push(NtETokenType.Positive);
    for (let i = 0; i < (negValue?.value ?? 0); i++) collection.push(NtETokenType.Negative);

    // console.log(collection);
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
      <button type="button" class="edit-tokens-to-draw" @click="incrTokensToDraw" :disabled="tokensToDraw >= maxDrawableTokens()">+</button>

      <p v-if="isAdrenalinChecked && tokTot()" class="tokens-to-draw with-adrenalin">{{ maxDrawableTokens() }}</p>
      <p v-else-if="tokTot()" class="tokens-to-draw">{{ tokensToDraw }}</p>
      <p v-else class="no-tokens-to-draw">Aggiungi dei token</p>

      <button type="button" class="edit-tokens-to-draw" @click="decrTokensToDraw" :disabled="tokensToDraw <= minValue || tokensToDraw == 1">-</button>
    </div>

    <div class="bottom">
      <button type="button" class="draw-tokens" @click="drawTokens" :disabled="tokensToDraw < minValue || !posValue || !negValue">estrai</button>
    </div>
  </main>

  <Teleport to="#full-modal-container">
    <DrawTokensModal
      v-if="isModalOpen"
      @close-modal="isModalOpen = false;"

      :collection="collection"
      :tokensToDraw="tokensToDraw.valueOf()"
      :isAdrenalinChecked="isAdrenalinChecked.valueOf()"
      :isConfusionChecked="isConfusionChecked.valueOf()"
    ></DrawTokensModal>
  </Teleport>
</template>

<style scoped>
  header {
    height: 52px;
  }

  main {
    margin: 0 auto;
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

  .top {
    padding-top: 12px;
    padding-bottom: 12px;

    background-color: rgba(102, 102, 102, 0.1);
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
    justify-content: center;
    align-items: center;
    flex-grow: 1;

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
