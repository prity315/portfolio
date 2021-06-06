import React, { Component } from "react";
import "../App.css";

class Social extends Component {
  render() {
    return (
      <div className="social">
        <a
          href="https://www.linkedin.com/in/pritykumari/"
          target="_blank"
          rel="noopener noreferrer"
        >
          <i class="fab fa-linkedin-in"></i>
        </a>
        <a
          href="https://github.com/prity315/"
          target="_blank"
          rel="noopener noreferrer"
        >
          <i class="fab fa-github"></i>
        </a>
        <a
          href="https://medium.com/@prity315"
          target="_blank"
          rel="noopener noreferrer"
        >
          <i class="fab fa-medium-m" />
        </a>
        <a
          href="https://www.facebook.com/prity-singh.716"
          target="_blank"
          rel="noopener noreferrer"
        >
          <i class="fab fa-facebook-f" />
        </a>
        <a
          href="https://www.instagram.com/rajprini"
          target="_blank"
          rel="noopener noreferrer"
        >
          <i class="fab fa-instagram" />
        </a>
      </div>
    );
  }
}

export default Social;
