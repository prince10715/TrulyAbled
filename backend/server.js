const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

app.post("/recommend", (req, res) => {
  const { disability, query } = req.body;

  let recommendations = [];

  if (disability === "Visual") {
    recommendations = [
      "Use a screen reader like TalkBack.",
      "Enable voice assistance.",
      "Increase text size."
    ];
  } else if (disability === "Hearing") {
    recommendations = [
      "Enable captions.",
      "Use vibration alerts.",
      "Use live transcription apps."
    ];
  } else if (disability === "Mobility") {
    recommendations = [
      "Use voice commands.",
      "Enable Assistive Touch.",
      "Use a stylus if needed."
    ];
  } else if (disability === "Cognitive") {
    recommendations = [
      "Break tasks into small steps.",
      "Use reminders.",
      "Reduce distractions."
    ];
  }

  res.json({
    disability,
    query,
    recommendations
  });
});

const PORT = 5000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});