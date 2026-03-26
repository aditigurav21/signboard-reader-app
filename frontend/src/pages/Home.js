import { useNavigate } from "react-router-dom";
import "../App.css";

function Home() {
  const navigate = useNavigate();

  return (
    <div className="container">
      <h1 className="title">Signboard Reader</h1>

      <button className="button" onClick={() => navigate("/upload")}>
        Upload Image
      </button>

      <br />

      <button className="button">
        Use Camera
      </button>
    </div>
  );
}

export default Home;