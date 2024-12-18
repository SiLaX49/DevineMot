import mongoose from "mongoose";

const DrawingSchema = new mongoose.Schema({
    imageURL: { type: String, required: true },
    correctAnswer: { type: String, required: true },
    fakeOptions: { type: [String], required: true },
    ratings: { type: [Number], default: [] },
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Drawing', DrawingSchema);
