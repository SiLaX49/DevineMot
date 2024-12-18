import mongoose from "mongoose";

const GallerySchema = new mongoose.Schema({
  drawingId: { type: mongoose.Schema.Types.ObjectId, ref: "Drawing", required: true },
  totalVotes: { type: Number, default: 0 },
});

export default mongoose.model("Gallery", GallerySchema);
