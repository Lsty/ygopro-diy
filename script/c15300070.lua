--七曜之魔女~水符「水母公主」~
function c15300070.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--sum limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c15300070.splimit)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,15300070)
	e3:SetCost(c15300070.decost)
	e3:SetTarget(c15300070.detg)
	e3:SetOperation(c15300070.deop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,15300071)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetTarget(c15300070.destg)
	e4:SetOperation(c15300070.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c15300070.pspcon)
	e6:SetOperation(c15300070.pspop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e7)
end
function c15300070.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c15300070.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c15300070.defilter(c)
	return c:IsSetCard(0x153) and c:GetActivateEffect():IsActivatable(tp)
end
function c15300070.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c15300070.defilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
end
function c15300070.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c15300070.defilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
end
function c15300070.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c15300070.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
end
function c15300070.pspfilter(c,tp)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0x155)
end
function c15300070.pspcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c15300070.pspfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),tp)
	else
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c15300070.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),tp)
	end
end
function c15300070.pspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Group.CreateGroup()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
		g=Duel.SelectMatchingCard(tp,c15300070.pspfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	else
		g=Duel.SelectMatchingCard(tp,c15300070.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	end
	local tc=g:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g:GetNext()
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end