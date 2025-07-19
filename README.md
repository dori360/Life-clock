# Life Clock

![Life Clock Banner](https://placehold.co/1200x300/2D3142/FFFFFF?text=Life+Clock&font=montserrat)

## Overview

Life Clock is a thoughtful web application that visualizes your remaining lifetime in a meaningful way. It transforms abstract concepts of time into tangible visual representations that help users understand and reflect on how they're spending their most valuable resource - time.

Using Flutter and Dart for web, this application creates an interactive experience that calculates and displays:
- The percentage of your life that has already elapsed
- Your remaining time in years, days, and hours
- Your "aware time" (waking hours) remaining, accounting for sleep

This project aims to foster mindfulness about time and encourage intentional living.

## Screenshots & Features

### Main Interface

![Main Interface](https://i.ibb.co/FFfHcfq/Generated-Image-July-19-2025-4-16-PM.jpg)  

The central interface displays a visually striking pie chart that dynamically updates to show the proportion of your life that has elapsed versus what remains. The percentage is displayed prominently in the center, providing an immediate understanding of your life's progression.

### Birth Date Selection

![Birth Date Selection](https://placehold.co/600x400/2D3142/FFFFFF?text=Birth+Date+Selection)

Users begin by selecting their birth date through an intuitive date picker. This crucial piece of information serves as the foundation for all subsequent calculations.

### Remaining Time Display

![Remaining Time Display](https://placehold.co/600x400/2D3142/FFFFFF?text=Time+Remaining+Panel)

The application presents your remaining time in multiple formats:
- **Years**: The number of years you have left based on average life expectancy
- **Days**: Your remaining lifetime expressed in days
- **Hours**: The total number of hours remaining
- **Aware Hours**: Your remaining waking hours, accounting for 8 hours of sleep per day

Each value is presented with both integer and decimal components, allowing for precise understanding of your time remaining.

### Color-Coded Visualization

![Color Progression](https://placehold.co/600x100/2D3142/FFFFFF?text=Color+Spectrum+Visualization)

The pie chart's color dynamically shifts along a spectrum from green (mostly remaining) to red (mostly elapsed), providing an intuitive visual cue about your life's progression.

## How It Works

### Technical Implementation

Life Clock leverages several technical components to deliver its functionality:

1. **DateTime Calculations**: The application performs precise calculations based on the difference between your birth date and the current moment, updated every second.

2. **Life Expectancy Modeling**: Currently using a default life expectancy of 80 years, the application converts this to seconds for accurate calculations.

3. **Sleep Adjustment**: The "aware time" calculation factors in 8 hours of sleep per day, recognizing that approximately 1/3 of our lives are spent sleeping.

4. **Real-Time Updates**: A timer refreshes all calculations every second, ensuring the displays are continuously accurate.

### Core Algorithm

At the heart of Life Clock is its time calculation algorithm:

```dart
Map<String, dynamic> calculateRemainingTime() {
  // Calculate total life seconds based on life expectancy
  final totalLifeSeconds = (lifeExpectancy * 365.25 * 24 * 60 * 60).round();
  
  // Calculate elapsed seconds from birth to current moment
  final elapsedSeconds = currentTime.difference(birthDate!).inSeconds;
  
  // Calculate remaining seconds
  final remainingSeconds = totalLifeSeconds - elapsedSeconds;
  
  // Convert to various time units
  final remainingYears = remainingSeconds / (365.25 * 24 * 60 * 60);
  final remainingDays = remainingSeconds / (24 * 60 * 60);
  final remainingHours = remainingSeconds / (60 * 60);
  
  // Calculate aware time (subtracting sleep)
  final awakeHoursPerDay = 24 - sleepHours;
  final remainingAwakeHours = remainingHours * (awakeHoursPerDay / 24);
  
  // Calculate percentage elapsed
  final percentageElapsed = elapsedSeconds / totalLifeSeconds;
  
  // Return all calculated values
  return { ... };
}
```

This function runs on every UI refresh, ensuring all displayed values are current and accurate.

## Installation & Setup

### Prerequisites

To run Life Clock, you'll need:

- Flutter SDK (version 2.10.0 or higher)
- Dart (version 2.16.0 or higher)
- A web browser (Chrome recommended for development)

### Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/life-clock.git
   cd life-clock
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application in Chrome**
   ```bash
   flutter run -d chrome
   ```

4. **Build for web deployment**
   ```bash
   flutter build web
   ```
   The build output will be in the `build/web` directory, ready to deploy to any web hosting service.

## Customization Options

Life Clock offers several opportunities for customization:

### Life Expectancy

The default life expectancy is set to 80 years, but this can be adjusted in the code:

```dart
// Default life expectancy (in years)
final double lifeExpectancy = 80.0;
```

### Sleep Hours

The application assumes 8 hours of sleep per day, which can be modified:

```dart
// Hours of sleep per day
final double sleepHours = 8.0;
```

### Theming

The UI uses a dark theme by default, which can be customized by modifying the `ThemeData` in the `MyApp` class.

## Project Structure

Life Clock follows a simple yet effective project structure:

```
lib/
├── main.dart         # Main application entry point and UI implementation
│
└── widgets/          # Custom widgets (when expanded)
    └── remaining_time_row.dart

```

The current implementation maintains all code in a single file for simplicity, but as the project grows, components can be separated into individual files.

## Roadmap & Future Enhancements

The following features are planned for future versions:

- **Personalized Life Expectancy**: Allow users to input factors like gender, location, and health metrics to estimate a more accurate life expectancy.

- **Additional Visualizations**: Implement alternative ways to visualize time, such as:
  - Calendar view showing weeks/months/years
  - Linear timeline with major life milestones
  - Age progression visualization

- **Data Persistence**: Save user preferences and birth date using local storage.

- **Custom Milestones**: Allow users to add significant events or goals to see how much time remains until or has passed since these milestones.

- **Notification System**: Optional reminders to promote mindfulness about time usage.

- **Time Well Spent**: Integration with productivity tools to help users assess whether they're spending their time in alignment with their values and goals.

## Contributing

Contributions to Life Clock are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your code follows the project's style guidelines and includes appropriate tests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Flutter and Dart teams for providing excellent tools for cross-platform development
- The concept of memento mori, which has inspired much of philosophy's thinking about mortality and time

---

## About the Developer

This project was created as a reflection on the finite nature of time and the importance of living intentionally. I believe that being aware of our limited time can inspire us to use it more meaningfully.

Feel free to reach out with questions, suggestions, or thoughts about the project!

[Your Name]  
[Your Email]  
[Your Social Links]

