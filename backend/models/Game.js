import mongoose from "mongoose";

const GameSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  drawingId: { type: mongoose.Schema.Types.ObjectId, ref: "Drawing", required: true },
  userAnswer: { type: String, required: true },
  isCorrect: { type: Boolean, required: true },
  score: { type: Number, required: true },
  createdAt: { type: Date, default: Date.now },
});

export default mongoose.model("Game", GameSchema);
