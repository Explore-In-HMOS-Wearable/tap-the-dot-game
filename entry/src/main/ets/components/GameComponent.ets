import Timer from '../services/TimerService';
import { GameState } from '../states/GameState';

interface GeneratedTypeLiteralInterface_1 {
  x: number;
  y: number;
}

@Component
export struct GameComponent {
  @ObjectLink timer: Timer;
  @ObjectLink gameState: GameState;
  @State score: number = 0;
  @State dotPosition: GeneratedTypeLiteralInterface_1 = { x: 100, y: 100 };
  context: UIContext = this.getUIContext();
  @State taps: number = 0;
  @State currentGoal: number = 4;

  aboutToAppear() {
    this.score = 0;
    this.taps = 0;
    this.currentGoal = 4;
    this.timer.refresh(this.currentGoal);
    this.timer.start();
    this.moveDot();
  }

  onDotTap() {
    if (!this.timer.running) {
      return;
    }

    // ----- scoring -----
    const reaction = this.timer.getElapsedTime();
    const points = Math.max(0, 4000 - reaction);
    this.score += points;
    this.taps += 1;

    // ----- difficulty ramp -----
    if (this.taps % 5 === 0 && this.currentGoal > 1) {
      this.currentGoal = Math.max(1, this.currentGoal - 0.5);
    }

    this.timer.refresh(this.currentGoal);
    this.timer.start();
    this.moveDot();
  }

  moveDot() {
    const screenSize = 466;
    const center = screenSize / 2;
    const dotSize = 32;
    const maxRadius = (screenSize - dotSize) / 2;

    const angle = Math.random() * 2 * Math.PI;
    const radius = Math.sqrt(Math.random()) * maxRadius;

    const x = center + radius * Math.cos(angle) - dotSize / 2;
    const y = center + radius * Math.sin(angle) - dotSize / 2;

    this.dotPosition = { x: this.context.px2vp(x), y: this.context.px2vp(y) };
  }

  build() {
    Stack() {
      Column() {
        Text(`Score: ${this.score}`)
          .fontSize(24)
          .fontColor(Color.White)
          .margin({ bottom: 10 });

        Text(this.timer.formattedTime())
          .fontSize(20)
          .fontColor(Color.White);
      }
      .alignItems(HorizontalAlign.Center)
      .margin({ top: 10 });

      if (this.timer.running) {
        Image($r('app.media.dot'))
          .width(32)
          .height(32)
          .position({ x: this.dotPosition.x, y: this.dotPosition.y })
          .onClick(() => this.onDotTap());
      }
    }
    .height('100%')
    .width('100%')
  }
}
