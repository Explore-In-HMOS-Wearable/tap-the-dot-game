@Observed
export default class Timer {
  private goalSec: number;
  private tickMs: number = 50;
  private startTs: number = 0;
  private intervalId: number | undefined;
  running: boolean = false;
  progressMs: number = 0;
  timerEndCallback: () => void;

  constructor(goalSeconds: number, cb: () => void = () => {
  }) {
    this.goalSec = goalSeconds;
    this.timerEndCallback = cb;
  }

  /** restart with same goal, clearing progress */
  start() {
    this.reset();
    this.running = true;
    this.startTs = Date.now();
    this.intervalId = setInterval(() => {
      this.progressMs = Date.now() - this.startTs;
      if (this.progressMs >= this.goalSec * 1000) {
        this.stop();
        this.timerEndCallback();
      }
    }, this.tickMs);
  }

  /** stop but keep progress value intact */
  stop() {
    if (this.intervalId !== undefined) {
      clearInterval(this.intervalId);
    }
    this.running = false;
    this.intervalId = undefined;
  }

  /** stop + clear progress counter */
  reset() {
    this.stop();
    this.progressMs = 0;
  }

  /** adopt new goal, clear progress; caller decides whether to start() */
  refresh(newGoalSec: number) {
    this.goalSec = newGoalSec;
    this.reset();
  }

  /** ms elapsed in current round */
  getElapsedTime(): number {
    return this.progressMs;
  }

  /** formatted  s.hh   (seconds + hundredths) */
  formattedTime(): string {
    const remainingMs = Math.max(0, this.goalSec * 1000 - this.progressMs);
    const sec = Math.floor(remainingMs / 1000);
    const hund = Math.floor((remainingMs % 1000) / 10);
    return `${sec}.${hund.toString().padStart(2, '0')} s`;
  }
}
