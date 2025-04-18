<template>
  <div class="header default-shadow">
    <h1 class="title">Not the End</h1>

    <p>BM</p>
  </div>
</template>

<style scoped>
  .header {
    display: flex;
    flex-direction: row;
    justify-content: space-between;

    padding: 8px;
  }

  .title {
    font-size: 1.5em;
    font-weight: 500;
  }

  .default-shadow {
    -webkit-box-shadow: 10px 10px 15px -15px rgba(0,0,0,0.75);
    -moz-box-shadow: 10px 10px 15px -15px rgba(0,0,0,0.75);
    box-shadow: 10px 10px 15px -15px rgba(0,0,0,0.75);
  }
</style>
