import Pagination from "./components/Pagination";

interface Props {
  searchParams: { page: string };
}
export default async function Home({ searchParams }: Props) {
  const params = await searchParams;
  const page = parseInt(params.page) || 1;

  return (
    <Pagination
      itemCount={100}
      pageSize={10}
      currentPage={page}
    />
  );
}