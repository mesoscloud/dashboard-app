defmodule Dashboard.Router do
  use Plug.Router

  #plug Plug.Logger

  plug Plug.Static, at: "/static", from: :dashboard

  plug :match
  plug :dispatch

  get "/events" do
    {:ok, events} = Riemann.query('true')

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(events, pretty: true))
  end

  get "/" do
    {:ok, events} = Riemann.query('service =~ "mesos %"')

    template = "<!DOCTYPE html>
<html>
  <head lang=\"en\">
    <meta charset=\"UTF-8\">
    <title></title>
    <script src=\"/static/d3.v3.min.js\" language=\"JavaScript\"></script>
    <script src=\"/static/liquidFillGauge.js\" language=\"JavaScript\"></script>
    <script src=\"/static/jquery-1.12.3.min.js\" language=\"JavaScript\"></script>
    <style>
        body {
          background-color: black;
        }

        .liquidFillGaugeText { font-family: Helvetica; font-weight: bold; }
    </style>
   </head>
  <body>

    <div style=\"padding-top: 250px\">

      <!-- cpus -->
      <svg id=\"fillgauge1\" width=\"33%\" height=\"400\"></svg>

      <!-- mem -->
      <svg id=\"fillgauge2\" width=\"33%\" height=\"400\"></svg>

      <!-- disk -->
      <svg id=\"fillgauge3\" width=\"33%\" height=\"400\"></svg>

  </div>

    <script language=\"JavaScript\">

      var config1 = liquidFillGaugeDefaultSettings();
      config1.circleColor = \"#c33\";
      config1.circleFillGap = 0.08;
      config1.circleThickness = 0.08;
      config1.textColor = \"#c33\";
      config1.waveAnimateTime = 5000;
      config1.waveColor = \"#c33\";
      config1.waveCount = 1;
      config1.waveTextColor = \"#fcc\";
      var gauge1 = loadLiquidFillGauge(\"fillgauge1\", 0, config1);

      var config2 = liquidFillGaugeDefaultSettings();
      config2.circleColor = \"#3c3\";
      config2.circleFillGap = 0.08;
      config2.circleThickness = 0.08;
      config2.textColor = \"#3c3\";
      config2.waveAnimateTime = 5000;
      config2.waveColor = \"#3c3\";
      config2.waveCount = 1;
      config2.waveTextColor = \"#cfc\";
      var gauge2 = loadLiquidFillGauge(\"fillgauge2\", 0, config2);

      var config3 = liquidFillGaugeDefaultSettings();
      config3.circleColor = \"#33c\";
      config3.circleFillGap = 0.08;
      config3.circleThickness = 0.08;
      config3.textColor = \"#33c\";
      config3.waveAnimateTime = 5000;
      config3.waveColor = \"#33c\";
      config3.waveCount = 1;
      config3.waveTextColor = \"#ccf\";
      var gauge3 = loadLiquidFillGauge(\"fillgauge3\", 0, config3);

      (function worker() {
          $.get('/events', function(data) {

          $.each(data, function(index, value) {
              if (value.service == 'mesos master/cpus_percent') {
                  gauge1.update((value.metric * 100).toFixed(0));
              } else if (value.service == 'mesos master/mem_percent') {
                  gauge2.update((value.metric * 100).toFixed(0));
              } else if (value.service == 'mesos master/disk_percent') {
                  gauge3.update((value.metric * 100).toFixed(0));
              }
          });

          setTimeout(worker, 5000);
      })})();

    </script>
  </body>
</html>
"

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, EEx.eval_string(template, []))
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
