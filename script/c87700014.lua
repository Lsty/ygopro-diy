--禁忌·四重存在
function c87700014.initial_effect(c)
	c:SetUniqueOnField(1,0,87700014)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c87700014.thcon1)
	e2:SetOperation(c87700014.thop1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetCondition(c87700014.thcon)
	e3:SetTarget(c87700014.thtg)
	e3:SetOperation(c87700014.thop)
	c:RegisterEffect(e3)
end
function c87700014.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEUP)~=0
		and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0 and rp==tp
end
function c87700014.thop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,87700014)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x877))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,87700014,RESET_PHASE+PHASE_END,0,1)
end
function c87700014.gfilter(c,tp)
	return c:IsSetCard(0x877)
end
function c87700014.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c87700014.gfilter,1,nil,tp)
end
function c87700014.filter1(c,e,tp)
	return c:IsFaceup() and (not e or c:IsRelateToEffect(e))
		and Duel.IsExistingMatchingCard(c87700014.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c87700014.filter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c87700014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c87700014.filter1,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c87700014.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c87700014.filter1,nil,e,tp)
	if g:GetCount()==0 then return end
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g=g:Select(tp,1,1,nil)
	end
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag=Duel.SelectMatchingCard(tp,c87700014.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc:GetCode())
	Duel.SendtoHand(ag,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,ag)
end