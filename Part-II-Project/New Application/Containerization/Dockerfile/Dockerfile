FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env

EXPOSE 8080
EXPOSE 80

WORKDIR /app

COPY movieapp/*.csproj ./
RUN dotnet restore

COPY movieapp/ ./
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "aspnetapp.dll"]