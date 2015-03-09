--改变的世界线
function c20400026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20400026.cost)
	e1:SetTarget(c20400026.target)
	e1:SetOperation(c20400026.activate)
	c:RegisterEffect(e1)
	if not LabMemGlobal then
		LabMemGlobal={}
		LabMemGlobal["Effects"]={}
	end
	LabMemGlobal["c20400026"]={}
end
function c20400026.filter(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsFaceup() and c:IsSetCard(0x204) and LabMemGlobal["Effects"]["c"..c:GetCode()] and (LabMemGlobal["Effects"]["c"..c:GetCode()]:GetTarget())(e,tp,eg,ep,ev,re,r,rp,0,nil)
end
function c20400026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20400026.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	local tc=Duel.SelectMatchingCard(tp,c20400026.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	c20400026[Duel.GetCurrentChain()]=LabMemGlobal["Effects"]["c"..tc:GetCode()]
	Duel.SendtoGrave(tc,REASON_RETURN+REASON_COST)
end
function c20400026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=c20400026[Duel.GetCurrentChain()]
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c20400026.activate(e,tp,eg,ep,ev,re,r,rp)
	local te=c20400026[Duel.GetCurrentChain()]
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end