--罪歌意识
function c1214590.initial_effect(c)
	c:SetUniqueOnField(1,0,1214590)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1214590,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,1214590)
	e1:SetTarget(c1214590.thtg)
	e1:SetOperation(c1214590.thop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1214590,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,1214590)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c1214590.descon)
	e2:SetTarget(c1214590.sptg)
	e2:SetOperation(c1214590.spop)
	c:RegisterEffect(e2)
end
function c1214590.filter(c)
	return c:IsCode(1314588) and c:IsAbleToHand()
end
function c1214590.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c1214590.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1214590.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c1214590.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c1214590.sumlimit)
		e1:SetLabel(tc:GetCode())
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e2,tp)
	end
end
function c1214590.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c1214590.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_DESTROY)
end
function c1214590.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1214590.cfilter,1,nil,tp)
end
function c1214590.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=eg:GetFirst()
	local p=tg:GetControler()
	if chk==0 then return Duel.GetLocationCount(p,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,1314588) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_GRAVE,0,1,1,nil,1314588)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c1214590.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	local p=tg:GetControler()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,p,false,false,POS_FACEUP_ATTACK)
	end
end