--夜盲症 米斯蒂娅
function c31141565.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c31141565.hspcon)
	e1:SetOperation(c31141565.hspop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31141565,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,31141566)
	e2:SetCondition(c31141565.con)
	e2:SetTarget(c31141565.target)
	e2:SetOperation(c31141565.operation)
	c:RegisterEffect(e2)
	--splimit
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ea:SetRange(LOCATION_GRAVE)
	ea:SetTargetRange(1,0)
	ea:SetTarget(c31141565.splimit)
	c:RegisterEffect(ea)
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetCode(EFFECT_CANNOT_SUMMON)
	eb:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	eb:SetRange(LOCATION_GRAVE)
	eb:SetTargetRange(1,0)
	eb:SetTarget(c31141565.splimit)
	c:RegisterEffect(eb)
end
function c31141565.con(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
	return e:GetHandler()==tc and tp==Duel.GetTurnPlayer()
end
function c31141565.splimit(e,c)
	return not c:IsRace(RACE_WINDBEAST)
end
function c31141565.spfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_WINDBEAST)
end
function c31141565.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetFlagEffect(tp,31141565)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c31141565.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c31141565.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(tp,31141565,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c31141565.splimit1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c31141565.splimit1(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x3d3)
end
function c31141565.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)==1
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c31141565.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c31141565.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end	