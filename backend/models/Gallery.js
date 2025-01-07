import mongoose from "mongoose";

const GallerySchema = new mongoose.Schema({
  drawingId: { type: mongoose.Schema.Types.ObjectId, ref: "Drawing", required: false },
  image: { type: String, required: true }, // URL de l'image
  addedBy: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true }, // Ajouté par quel utilisateur
  totalVotes: { type: Number, default: 0 },
  createdAt: { type: Date, default: Date.now },
});

export default mongoose.model("Gallery", GallerySchema);
