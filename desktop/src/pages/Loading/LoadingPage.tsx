import Loading, { LoadingProps } from "@/components/ui/Loading/Loading";

export default function LoadingPage(props: LoadingProps) {
  return (
    <div className="h-screen grid place-items-center">
      <Loading {...props} />
    </div>
  );
}
