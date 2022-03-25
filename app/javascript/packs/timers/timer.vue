<template>
  <div class="container">
    <div class="content">
      <div class="information">
        <div class="information__item">
        Token: {{ token }}
        </div>
        <div class="information__item">
        Link: {{ link }}
        </div>
        <div v-if="debug">
          <div class="information__item">
            Debug: {{ debug }}
          </div>
          <div class="information__item">
            {{ timerJson }}
          </div>
          <div class="information__item">
            {{ startTime }}
          </div>
          <div class="information__item">
            {{ currentTime }}
          </div>
          <div class="information__item">
            {{ loading }}
          </div>
        </div>
      </div>
      <div class='timer'>
      {{ timerString }}
      </div>
      <button v-on:click="resetTimer" class="reset-button">
        reset!
      </button>
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
* {
  box-sizing: border-box;
}

.container {
  color: #666;
  box-sizing: content-box;
  position: fixed;
  left: 0;
  top: 0;

  background: #333;
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.content {
  position: fixed;
  top: calc(50% - 95vh/2);
  left: calc(50% - 80vw/2);
  width: 80vw;
  height: auto;
  overflow-y: scroll;

  padding: 50px;

  border-radius: 20px;
  background: #eee;

  font-family: "Nitalagoruika-05", "Aktiv Grotesk","Segoe UI",Helvetica,Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
  text-align: center;
}

.information {
  border: 1px #ccc solid;
  border-radius: 20px;
}

.timer {
  margin: 20px auto;
  font-size: 10rem;
}

.reset-button {
  font-size: 3rem;
  padding: .5rem 1rem;

  text-decoration: none;
  border-radius: 10px;
  display: inline;
  cursor: pointer;

  border: 1px solid #666;
  color: #666;
  background: #fff;

  transition: 0.3s;
}

.reset-button:hover {
  color: #fff;
  background: #666;
}

</style>
