FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5020

ENV ASPNETCORE_URLS=http://+:5020

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["SchoolManagementApp.MVC.csproj", "./"]
RUN dotnet restore "SchoolManagementApp.MVC.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "SchoolManagementApp.MVC.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SchoolManagementApp.MVC.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SchoolManagementApp.MVC.dll"]
