<template>
  <div>
  Token: {{ token }}
  </div>
  <div>
  Link: {{ link }}
  </div>
  <div>
  {{ timerString }}
  </div>
  <button v-on:click="resetTimer">
    reset!
  </button>
  <div v-if="debug">
    <div>
    {{ debug }}
    </div>
    <div>
      {{ timerJson }}
    </div>
    <div>
      {{ startTime }}
    </div>
    <div>
      {{ currentTime }}
    </div>
    <div>
      {{ loading }}
    </div>
  </div>
</template>

<script>
import axios from 'axios';

const csrfToken = document.getElementsByName("csrf-token")[0].getAttribute("content");
axios.defaults.headers.common["X-CSRF-Token"] = csrfToken;

export default {
  data() {
    return {
      link: location.href,
      token: '',
      currentTime: 0,
      timerIntervalObject: null,
      updateIntervalObject: null,
      timerJson: {},
      debug: false,
    }
  },

  async mounted() {
    this.token = window.token
    this.debug = window.debug

    this.currentTime = this.startTime

    this.ovserveTimerRecord();
    this.startCountUp();
  },

  methods: {
    countUp: function() {
      this.currentTime = Date.now();
    },

    ovserveTimerRecord: function() {
      let thisObject = this
      if (this.updateIntervalObject) clearInterval(this.updateIntervalObject)
      this.updateIntervalObject = setInterval(function() {
        thisObject.updateTimer()
      }, 1000)
    },

    startCountUp: function() {
      let thisObject = this
      if (this.timerIntervalObject) clearInterval(this.timerIntervalObject)
      this.timerIntervalObject = setInterval(function() {
        thisObject.countUp()
      }, 100)
    },

    updateTimer: function() {
      let thisObject = this;
      this.requestTimer().then(function(response) {
        thisObject.timerJson = response.data
      }).catch(function(error) {
        console.log(`ERROR: ${error}`)
      })
    },

    resetTimer: function() {
      return axios.put(`/timers/${this.token}/reset`);
    },

    requestTimer: function() {
      return axios.get(`/timers/${this.token}.json`);
    },
  },

  computed: {
    loading() {
      return !Boolean(this.timerJson.start_at)
    },

    startTime() {
      if (!this.timerJson.start_at) return this.currentTime
      return new Date(this.timerJson.start_at).getTime()
    },

    timerString() {
      if (this.loading) return '-- : --'
      let diff = Math.abs(this.currentTime - this.startTime)
      let seconds = parseInt(diff / 1000)
      let minutes = (parseInt(seconds / 60))
      let rest_seconds = seconds - (minutes * 60)
      return `${minutes} : ${rest_seconds}`
    }
  }
}
</script>

<style scoped>
</style>
