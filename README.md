# Noongil — Assistive Vision System

> **See beyond sight. Navigate with confidence.**

**Noongil** is a browser-based assistive vision system designed to help visually impaired and low-vision individuals better understand their immediate surroundings.

Using **real-time computer vision**, Noongil detects objects through the device camera, estimates their approximate distance, and communicates detected surroundings through **spoken voice feedback**.

The entire system is designed to run directly in the browser, with camera processing performed locally on the user's device.

---

## Inspiration

Noongil is inspired by the fictional **NoonGil (눈길)** assistive technology featured in the Korean drama **Start-Up**.

In the series, **Nam Do-san** and the Samsan Tech team develop NoonGil as an assistive application intended to help visually impaired people understand their surroundings. The idea becomes particularly meaningful through **Choi Won-deok**, Dal-mi's grandmother, who is losing her eyesight.

This project takes inspiration from that fictional concept and explores how modern browser-based computer vision can be used to create a similar type of assistive experience.

> **This is an independent project inspired by the fictional concept from Start-Up and is not affiliated with the drama, its creators, or its production company.**

---

## Features

### Real-Time Camera Vision

Noongil uses the device camera to continuously analyze the user's surroundings.

* Live camera feed
* Front and rear camera support
* Camera switching
* Real-time object detection
* Responsive browser-based interface

### AI Object Detection

The application uses **TensorFlow.js** with **COCO-SSD** for real-time object detection directly in the browser.

Currently detectable objects include common categories such as:

* Person
* Car
* Bus
* Truck
* Bicycle
* Motorcycle
* Dog
* Cat
* Chair
* Bottle
* Cup
* Laptop
* Cell phone
* TV
* Book
* Backpack

Detection results are displayed visually using bounding boxes over the live camera feed.

### Approximate Distance Estimation

Noongil estimates the approximate distance of detected objects using their bounding-box width and an assumed real-world object width.

The basic calculation is:

```text
Distance ≈ (Real Object Width × Focal Length) / Bounding Box Width
```

Different object categories are assigned approximate real-world widths to make the estimation possible.

Objects detected within approximately **1 meter** are treated as nearby obstacles and highlighted accordingly.

> Distance values are estimates rather than measurements. Accuracy can vary significantly depending on camera calibration, object size, viewing angle, lighting, and detection quality.

### Voice Radar

Detected objects can be communicated through the browser's **Speech Synthesis API**.

For example:

```text
Person at 1.8 meters
Chair at 0.9 meters
Car at 4.2 meters
```

To prevent continuous repetition, Noongil uses a re-speak interval so the same object is not announced every frame.

Users can also:

* Mute voice feedback
* Resume voice feedback
* Receive multiple detected objects in a single announcement

### Spatial Detection Stream

The application maintains a live detection log containing:

* Detection time
* Object name
* Estimated distance
* Near/far classification

This provides a visual history of recently detected objects.

### Live Spatial Metrics

The interface provides three live metrics:

| Metric               | Description                                        |
| -------------------- | -------------------------------------------------- |
| **Nearest Obstacle** | Closest detected object with an estimated distance |
| **Objects In View**  | Number of objects currently detected               |
| **Voice Radar**      | Current voice feedback state                       |

### Privacy-First Design

One of the core goals of Noongil is **local processing**.

The application is designed so that:

* Camera access stays within the browser.
* Object detection runs using TensorFlow.js.
* Video frames are not intentionally uploaded to a server.
* No backend is required for the core detection pipeline.
* Voice feedback is generated locally through the browser.
* Users can stop the camera at any time.

Noongil is therefore designed around the principle:

> **Your surroundings should remain yours.**

Third-party libraries are currently loaded from CDNs. Privacy behavior should therefore be evaluated alongside the selected dependencies and deployment configuration before making absolute privacy guarantees for a production system.

---

## Technology Stack

### Frontend

* HTML5
* CSS3
* Vanilla JavaScript

### Computer Vision

* TensorFlow.js
* COCO-SSD

### Browser APIs

* `MediaDevices.getUserMedia()`
* `SpeechSynthesis API`
* HTML5 `<video>`
* HTML5 `<canvas>`

### Design

* Responsive CSS
* Glassmorphism-inspired interface
* Custom HUD elements
* Real-time camera overlay
* Responsive mobile layout
* Google Fonts:

  * Outfit
  * JetBrains Mono

---

## How It Works

The Noongil pipeline can be summarized as:

```text
┌─────────────────────┐
│    Device Camera    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│    Video Stream     │
│     in Browser      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│    COCO-SSD Model   │
│   Object Detection  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Object + Bounding   │
│      Box Data       │
└──────────┬──────────┘
           │
      ┌────┴─────┐
      ▼          ▼
┌───────────┐ ┌───────────────┐
│ Distance  │ │ Spatial       │
│ Estimate  │ │ Classification│
└─────┬─────┘ └──────┬────────┘
      │              │
      └──────┬───────┘
             ▼
    ┌──────────────────┐
    │ Voice Feedback   │
    │ + Visual HUD     │
    └──────────────────┘
```

---

## Distance Estimation

Noongil uses a simplified monocular distance estimation technique.

For supported objects:

```javascript
distance = realWidth * focalLength / boundingBoxWidth;
```

The current implementation uses an approximate focal length:

```javascript
const FOCAL = 700;
```

and predefined approximate object widths:

```javascript
const WIDTH = {
    person: 0.45,
    car: 1.8,
    bus: 2.5,
    truck: 2.5,
    bicycle: 0.6,
    motorcycle: 0.8,
    dog: 0.3,
    cat: 0.2,
    chair: 0.5,
    bottle: 0.07,
    cup: 0.08,
    laptop: 0.35,
    "cell phone": 0.07,
    tv: 1.0,
    book: 0.15,
    backpack: 0.3
};
```

This provides a useful approximation for the prototype, but it should **not be considered a safety-critical distance measurement system**.

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/noongil-vision.git
cd noongil-vision
```

### 2. Start a local server

Because browser camera APIs generally require a secure context such as **HTTPS** or `localhost`, don't simply rely on opening the HTML file directly.

For example, with Python:

```bash
python -m http.server 8000
```

Then open:

```text
http://localhost:8000
```

### 3. Allow camera access

Click:

**Start Camera**

Grant the browser permission to access the camera.

The COCO-SSD model will then load and begin analyzing the live video stream.

---

## Project Structure

A simple deployment can use:

```text
noongil-vision/
│
├── index.html
├── city_background.png
├── textimg.png
├── README.md
└── assets/
    └── ...
```

The current prototype is primarily contained within `index.html`, including:

* UI
* Styling
* Camera handling
* Model loading
* Object detection
* Distance estimation
* Voice feedback
* Detection logging
* Metrics

---

## Controls

| Control          | Function                                |
| ---------------- | --------------------------------------- |
| **Start Camera** | Starts the camera and AI detection      |
| **Flip Camera**  | Switches between front and rear cameras |
| **Stop Camera**  | Stops the camera and detection          |
| **Mute Voice**   | Disables spoken feedback                |
| **Unmute Voice** | Re-enables spoken feedback              |

---

## Accessibility Goal

Noongil is designed around a simple idea:

> **Technology should help people understand the world around them, not make them adapt to technology.**

The project explores how computer vision and voice interfaces can provide additional environmental awareness for people with visual impairments or low vision.

Potential applications include:

* Detecting nearby objects
* Identifying potential obstacles
* Providing approximate spatial information
* Describing objects through voice
* Supporting independent movement

Noongil is intended as an **assistive technology prototype**, not a replacement for mobility aids, trained assistance, or professional accessibility equipment.

---

## Limitations

Noongil is currently a prototype and has several important limitations.

### Object Detection

COCO-SSD can only recognize the object categories supported by its trained model.

Objects may also be:

* Missed
* Misclassified
* Detected inconsistently
* Occluded
* Affected by lighting conditions

### Distance Estimation

Distance estimation is approximate and depends on assumptions about:

* Actual object size
* Camera focal length
* Bounding-box accuracy
* Camera angle
* Perspective
* Lighting
* Object orientation

### Camera Environment

Performance can vary depending on:

* Device hardware
* Browser
* Camera quality
* CPU/GPU performance
* Lighting
* Background complexity

### Safety

**Noongil should not currently be relied upon as a sole navigation or collision-avoidance system.**

The system is an experimental assistive-vision project and should be treated accordingly.

---

## Future Roadmap

Possible future improvements include:

* [ ] Better distance estimation through camera calibration
* [ ] Depth estimation using monocular depth models
* [ ] Improved obstacle prioritization
* [ ] Directional voice feedback
* [ ] Left / center / right spatial positioning
* [ ] Object tracking between frames
* [ ] Better pedestrian detection
* [ ] Custom-trained accessibility-focused detection model
* [ ] More natural voice descriptions
* [ ] Haptic feedback
* [ ] Offline model caching
* [ ] Progressive Web App support
* [ ] Improved mobile optimization
* [ ] Low-light detection improvements
* [ ] Multi-language voice feedback
* [ ] Custom user calibration
* [ ] Accessibility-focused UI modes

---

## Current Prototype

The current implementation demonstrates the core Noongil concept:

```text
Camera
   ↓
Object Detection
   ↓
Bounding Box
   ↓
Distance Estimation
   ↓
Obstacle Classification
   ↓
Voice Announcement
   ↓
Detection Log
```

The goal is not simply to identify objects, but to transform visual information into **actionable spatial feedback**.

---

## Inspiration vs. Implementation

| *Start-Up* NoonGil                   | This Project                              |
| ------------------------------------ | ----------------------------------------- |
| Fictional assistive technology       | Working browser prototype                 |
| Designed for visually impaired users | Designed as an assistive-vision prototype |
| AI-based environmental understanding | TensorFlow.js + COCO-SSD                  |
| Voice-based assistance               | Browser Speech Synthesis                  |
| Helps understand surroundings        | Real-time object detection                |
| Fictional implementation             | Open-source experimental implementation   |

The project is **inspired by the fictional NoonGil concept**, while the implementation, interface, computer-vision pipeline, and engineering decisions are independently developed.

---

## Author

**Anushka Verma**

> *Sail off without a map.*

Noongil is an exploration of how accessible AI and browser-based computer vision can help create more independent and privacy-conscious assistive experiences.

---

## Disclaimer

Noongil is an experimental/open-source assistive technology project.

It is **not a medical device**, certified mobility aid, or guaranteed collision-avoidance system. Distance estimates and object detections may be inaccurate.

Users should not depend solely on Noongil for navigation or personal safety.

---

## Why Noongil?

Vision is more than seeing.

It's understanding **what is around you, where it is, and how close it is**.

Noongil explores whether AI can help bridge that gap — turning a camera into an additional layer of spatial awareness while keeping processing as local and private as possible.

**No map. No cloud. Just a little more awareness of the world around you.**
