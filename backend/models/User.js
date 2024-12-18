import mongoose from "mongoose";

const UserSchema = new mongoose.Schema({
    username: { type: String, required: true, unique: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    scores: { type: [Number], default: [] },
    favoriteDrawings: { type: [mongoose.Schema.Types.ObjectId], ref: 'Drawing' },
    createdAt: { type: Date, default: Date.now }
});

export default mongoose.model("User", UserSchema);
