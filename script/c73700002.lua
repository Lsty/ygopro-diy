--胧月花枝 铃仙·优昙华院·因幡
function c73700002.initial_effect(c)
	--change battle target
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,73700002)
	e1:SetCondition(c73700002.cbcon)
	e1:SetTarget(c73700002.thtg)
	e1:SetOperation(c73700002.cbop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c73700002.atkcon)
	e2:SetOperation(c73700002.atkop)
	c:RegisterEffect(e2)
end
function c73700002.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return r~=REASON_REPLACE and bt:IsFaceup() and bt:IsSetCard(0x737) and bt:GetControler()==c:GetControler()
end
function c73700002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function c73700002.cbop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function c73700002.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c73700002.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsRace(RACE_BEAST) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73700002,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c73700002.efilter)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end
function c73700002.efilter(e,te)
	return te:IsActiveType(TYPE_EFFECT) and e:GetHandlerPlayer()~=te:GetHandlerPlayer()
end