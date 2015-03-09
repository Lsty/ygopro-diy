--神殿
function c187199010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3e1))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e3)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87902575,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1)
	e2:SetCondition(c187199010.con)
	e2:SetTarget(c187199010.rmtg)
	e2:SetOperation(c187199010.rmop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66957584,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,187199010)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c187199010.spcost)
	e3:SetTarget(c187199010.sptg)
	e3:SetOperation(c187199010.spop)
	c:RegisterEffect(e3)
end
function c187199010.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c187199010.filter,1,nil) and eg:GetCount()>=1
end
function c187199010.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,187199010)==0 and e:GetHandler():IsRelateToEffect(e) end
	local g=eg:Filter(c187199010.filter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:GetCount(),0,0)
	Duel.RegisterFlagEffect(tp,187199010,RESET_PHASE+PHASE_END,0,1)
end
function c187199010.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsLocation(LOCATION_MZONE)
end
function c187199010.filter2(c,e,tp)
	return c:IsFaceup() and c:IsRelateToEffect(e) and c:IsCanTurnSet() and c:IsLocation(LOCATION_MZONE)
end
function c187199010.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c187199010.filter2,nil,e,tp)
	if g:GetCount()>0 then
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENCE)
	end
end
function c187199010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c187199010.filter3(c,e,tp)
	return c:IsSetCard(0x3e1) and c:IsAbleToHand()
end
function c187199010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c187199010.filter3(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c187199010.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectTarget(tp,c187199010.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c187199010.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end