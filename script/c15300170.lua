--七曜之魔女~月符「沉静的月神」~
function c15300170.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c15300170.condition)
	c:RegisterEffect(e1)
	--sum limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c15300170.spcon)
	e2:SetTarget(c15300170.splimit)
	c:RegisterEffect(e2)
	--summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_PZONE)
	e5:SetProperty(EFFECT_FLAG_REPEAT+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCountLimit(1)
	e5:SetTarget(c15300170.destg)
	e5:SetOperation(c15300170.desop)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCountLimit(1,15300170)
	e6:SetTarget(c15300170.psptg)
	e6:SetOperation(c15300170.pspop)
	c:RegisterEffect(e6)
end
function c15300170.filter(c)
	return c:IsFacedown() or not c:IsSetCard(0x153)
end
function c15300170.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c15300170.filter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)==0
end
function c15300170.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0x153)
end
function c15300170.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x153)
end
function c15300170.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c15300170.filter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c15300170.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c15300170.pspfilter(c)
	local seq=c:GetSequence()
	return (seq~=6 or seq~=7) and c:IsAbleToDeckAsCost() and c:IsSetCard(0x153)
end
function c15300170.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		if Duel.GetMatchingGroupCount(c15300170.acfilter,c:GetControler(),LOCATION_SZONE,0,nil)==2 then
		return e:GetHandler():GetActivateEffect():IsActivatable(tp)
			and Duel.IsExistingMatchingCard(c15300170.pspfilter,tp,LOCATION_SZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(c15300170.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,e:GetHandler(),tp)
		else
		return e:GetHandler():GetActivateEffect():IsActivatable(tp)
			and Duel.IsExistingMatchingCard(c15300170.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,e:GetHandler(),tp)
		end
	end
end
function c15300170.pspop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Group.CreateGroup()
	if Duel.GetMatchingGroupCount(c15300170.acfilter,c:GetControler(),LOCATION_SZONE,0,nil)==2 then
		g=Duel.SelectMatchingCard(tp,c15300170.pspfilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler(),tp)
		local g1=Duel.SelectMatchingCard(tp,c15300170.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,g:GetFirst())
		g:Merge(g1)
	else
		g=Duel.SelectMatchingCard(tp,c15300170.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,2,e:GetHandler(),tp)
	end
	local tc=g:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g:GetNext()
	end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local te=c:GetActivateEffect()
	local tep=c:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	Duel.RaiseEvent(c,EVENT_CHAIN_SOLVED,c:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end