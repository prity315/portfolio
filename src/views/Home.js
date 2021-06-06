import React, { Component } from "react";
import profilepic from "../images/profilepic.jpg";
import ReactTypingEffect from "react-typing-effect";
import "../App.css";
import Social from "../components/Social";

class Home extends Component {
  render() {
    return (
      <div className="condiv home">
        <img src={profilepic} alt="prifile_pic" className="profilepic"></img>
        <ReactTypingEffect
          className="typingeffect"
          text={["I'm Prity Kumari.", "I'm a backend develoer."]}
          speed={100}
          eraseDelay={700}
        />
        <Social/>
      </div>
    );
  }
}

export default Home;
