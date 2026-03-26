import { useState } from "react";
import { useNavigate } from "react-router-dom";
import "../App.css";

function Upload() {
  const [image, setImage] = useState(null);
  const navigate = useNavigate();

  const handleImage = (e) => {
    setImage(URL.createObjectURL(e.target.files[0]));
  };

  return (
    <div className="container">
      <h2 className="title">Upload Image</h2>

      <input type="file" accept="image/*" onChange={handleImage} />

      <br /><br />

      {image && <img src={image} alt="preview" width="300" />}

      <br /><br />

      <button 
  className="button" 
  onClick={() => navigate("/result", { state: { image } })}
>
  Process Image
</button>
    </div>
  );
}

export default Upload;