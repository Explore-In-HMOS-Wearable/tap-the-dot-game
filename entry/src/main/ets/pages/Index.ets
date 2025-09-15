import { GameComponent } from '../components/GameComponent';
import Timer from '../services/TimerService';
import { GameState } from '../states/GameState';


@Entry
@Component
struct Index {
  @State showGame: boolean = false;
  @State timer: Timer = new Timer(4, () => {
  });
  @State gameState: GameState = new GameState();

  startGame() {
    this.timer = new Timer(4, () => {
      this.timer.stop();
      this.gameState.gameRunning = false;
    });

    this.gameState = new GameState();
    this.showGame = true;
  }

  build() {
    Stack() {
      if (!this.showGame || !this.gameState.gameRunning) {
        Column({ space: 20 }) {
          if (this.gameState.isGameOver) {
            Text('Game Over')
              .fontSize(26)
              .fontColor(Color.Red);
          }

          Text('Tap the Dot')
            .fontSize(20)
            .fontColor(Color.White);

          Button('Start Game')
            .fontSize(22)
            .onClick(() => this.startGame());
        }
        .alignItems(HorizontalAlign.Center);
      } else {
        GameComponent({ timer: this.timer, gameState: this.gameState });
      }
    }
    .linearGradient({
      direction: GradientDirection.Left,
      angle: 12,
      colors: [
        [0x0d1b2a, 0.0],
        [0x1b263b, 0.25],
        [0x415a77, 0.5],
      ]
    })
    .expandSafeArea()
    .width('100%')
    .height('100%');
  }
}
