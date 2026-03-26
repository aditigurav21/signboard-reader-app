import { useLocation } from "react-router-dom";
import "../App.css";

function Result() {
  const location = useLocation();
  const image = location.state?.image;

  return (
    <div className="container">
      <h2 className="title">Result</h2>

      {image && <img src={image} alt="uploaded" width="300" />}

      <br /><br />

      <p><b>Detected Text:</b> ---</p>
      <p><b>Translated Text:</b> ---</p>
    </div>
  );
}

export default Result;