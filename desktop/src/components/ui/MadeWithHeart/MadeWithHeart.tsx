export default function MadeWithHeart() {
  // TODO: Add a cool hover effect
  return (
    <div className="group">
      Made with ❤️ by{" "}
      <a
        className="bg-left-bottom bg-gradient-to-r from-flify pb-1 to-blue-400 bg-[length:0%_2px] bg-no-repeat group-hover:bg-[length:100%_2px] transition-all duration-500 ease-out active:text-flify"
        href="https://github.com/Arciiix"
        target="_blank"
        rel="noreferrer noopener"
      >
        <b>Artur Nowak</b>
      </a>
    </div>
  );
}
