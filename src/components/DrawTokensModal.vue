<script setup lang="ts">
  import { defineProps, ref, type Ref } from 'vue';
  import { useLocalStorage } from '@vueuse/core';
  import CloseIcon from './CloseIcon.vue';

  enum NtETokenType {
    Positive = 1,
    Negative = 0
  }

  const _maxDrawableTokens = useLocalStorage('NtE__maxTokens', 4, { mergeDefaults: true });

  /** inputs - start */
  const props = defineProps(['tokensToDraw', 'isAdrenalinChecked', 'isConfusionChecked', 'collection']);

  const tokensToDraw: number = props.tokensToDraw;
  const isAdrenalinChecked: boolean = props.isAdrenalinChecked;
  const isConfusionChecked: boolean = props.isConfusionChecked;
  const collection: number[] = props.collection;
  /** inputs - end */


  const posResults: Ref<number, number> = ref(0);
  const negResults: Ref<number, number> = ref(0);

  let maxRiskTokensReached: boolean = false;
  function initialDraw() {
    maxRiskTokensReached = (tokensToDraw == _maxDrawableTokens.value);

    const n = isAdrenalinChecked ? _maxDrawableTokens.value : tokensToDraw;

    for (let i = 0; i < n; i++) {
      draw();
    }
  }

  let emptyBag: boolean = false;
  function draw() {
    const e = collection.pop();
    if (e == NtETokenType.Positive) posResults.value++;
    else if (e == NtETokenType.Negative) negResults.value++;

    if (!collection.length) emptyBag = true;

    // console.log("draw", collection.length, emptyBag);
  }

  let hasRiskedAlready: boolean = false;
  function risk() {
    hasRiskedAlready = true;
    for (let i = 0; i < _maxDrawableTokens.value - tokensToDraw; i++) {
      draw();
    }
  }


  function getRemainingTokens(type: number) {
    return collection.filter(tkn => tkn == type).length;
  }


  const showBagIcon: Ref<boolean, boolean> = ref(false);
  const showBagContent: Ref<boolean, boolean> = ref(false);
  function clickOnBag() {
    if (!showBagIcon.value) showBagIcon.value = true;
    else if (showBagContent.value) {
      showBagContent.value = false;
      showBagIcon.value = false;

      collection.sort(() => (Math.random() > .5) ? 1 : -1);
    } else {
      showBagContent.value = true;
    }
  }


  function init() {
    if ((collection ?? []).length == tokensToDraw) hasRiskedAlready = true;
    collection.sort(() => (Math.random() > .5) ? 1 : -1);

    // if (isAdrenalinChecked) tokensToDraw = _maxDrawableTokens.value;
    if (isConfusionChecked) {
      // console.log("prima", collection);
      collection.forEach(tkn => {
        if (tkn == NtETokenType.Positive) {
          if (((Math.random() > .5) ? 1 : -1) < 0) {
            tkn = NtETokenType.Negative;
            // console.log("r");
          } else {
            // console.log("p");
          }
        }
      });
      // console.log("dopo", collection);
    }

    initialDraw();
  }
  init();
</script>

<template>
  <div class="modal-overlay"></div>
  <!-- <div class="full-modal">
    <p>test</p>

    <button @click="$emit('close-modal')">close</button>
  </div> -->

  <div class="full-modal">
    <div class="close-icon" @click="$emit('close-modal')">
      <CloseIcon></CloseIcon>
    </div>

    <div :class="{'bag-icon': true, 'active': showBagIcon}" @click="clickOnBag()">
      <img src="../../public/nte_bag.png" alt="nte_bag" v-if="showBagIcon">
    </div>

    <div class="hexagon-container hexagon-container--pos">
      <div class="hexagon hexagon-pos"></div>
      <div class="hex-label">
        <p class="pos">
          {{posResults}}
        </p>
      </div>
    </div>

    <div>
      <p class="pos-tokens centered">
        Token Positivi
      </p>

      <button type="button" class="risk-btn" @click="risk()" :disabled="hasRiskedAlready || emptyBag || maxRiskTokensReached" v-if="!showBagContent">
        rischia
      </button>
      <div class="bag-content" v-if="showBagContent">
        <p class="bag-content--label-pos">
          altri {{ getRemainingTokens(NtETokenType.Positive) }} x
        </p>
        <div class="hexagon-container hexagon-container--pos">
          <div class="hexagon hexagon-pos"></div>
        </div>

        <div style="width: 20%;"></div>

        <p class="bag-content--label-neg">
          altri {{ getRemainingTokens(NtETokenType.Negative) }} x
        </p>
        <div class="hexagon-container hexagon-container--neg">
          <div class="hexagon hexagon-neg"></div>
        </div>
      </div>
      
      <p class="neg-tokens centered">
        Token Negativi
      </p>
    </div>

    <div class="hexagon-container hexagon-container--neg">
      <div class="hexagon hexagon-neg"></div>
      <div class="hex-label">
        <p class="neg">
          {{negResults}}
        </p>
      </div>
    </div>
  </div>
</template>

<style scoped>
  .full-modal {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }

  .close-icon {
    position: fixed;
    top: 8px;
    right: 8px;
    width: fit-content;
    height: fit-content;
    z-index: 9998;
  }

  .close-icon .icon {
    height: 30px;
    width: 30px;
    font-size: 30px;
  }


  .hexagon-container {
    position: relative;

    margin-left: auto;
    margin-right: auto;
    width: fit-content;
  }

  .hexagon {
    position: relative;
    width: 200px;
    height: 115.47px;
    background-color: #64c7cc;
    margin: 57.74px 0;
  }

  .hexagon:before,
  .hexagon:after {
    content: "";
    position: absolute;
    width: 0;
    border-left: 100px solid transparent;
    border-right: 100px solid transparent;
  }
  
  .hexagon:before {
    bottom: 100%;
    border-bottom: 57.74px solid #64c7cc;
  }
  
  .hexagon:after {
    top: 100%;
    width: 0;
    border-top: 57.74px solid #64c7cc;
  }

  .hexagon-pos {
    background-color: orange;

    &:before {
      border-bottom-color: orange;
    }

    &:after {
      border-top-color: orange;
    }
  }

  .hexagon-neg {
    background-color: purple;

    &:before {
      border-bottom-color: purple;
    }

    &:after {
      border-top-color: purple;
    }
  }


  .hexagon-container--pos {
    padding-top: 20px;
  }

  .hexagon-container--pos .hex-label {
    top: calc(57.74px - 35px + 20px - 6px);
  }

  .hexagon-container--neg {
    padding-bottom: 20px;
  }

  .hexagon-container--neg .hex-label {
    top: calc(57.74px - 35px - 6px);
  }


  .hex-label {
    position: absolute;
    left: 0;
    width: 100%;
    z-index: 9999;
  }

  .hex-label p {
    margin: 0;
    text-align: center;
    font-size: 115.47px;
    font-weight: bold;
  }

  .hex-label p.pos {
    color: white;
  }

  .hex-label p.neg {
    color: white;
  }


  p.pos-tokens,
  p.neg-tokens {
    margin-top: 0.5em;
    margin-bottom: 0.5em;
  }


  button.risk-btn {
    width: 100%;
    height: 40px;

    font-weight: bold;
    text-transform: uppercase;
    font-size: 1em;
    letter-spacing: 0.1em;
  }


  

  .bag-icon {
    position: fixed;
    bottom: 8px;
    right: 8px;
    width: 44px;
    height: 44px;

    padding: 8px;
    border-radius: 50%;
  }
  
  .bag-icon.active {
    background-color: black;
  }

  .bag-icon img {
    width: 100%;
    height: 100%;
  }

  .bag-content {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: center;

    height: 40px;
  }
  
  .bag-content .hexagon-container {
    width: 40px;
    height: 40px;
    transform: scale3d(0.1, 0.1, 1);
    padding: 0;
    margin-left: 0px;
    margin-right: 0px;
  }

  .bag-content .hexagon-container .hexagon {
    margin: 0;
  }

  .bag-content--label-pos,
  .bag-content--label-neg {
    transform: translate3d(10px, 10px, 0);
  }
</style>
