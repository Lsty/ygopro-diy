--怪物猎人 水兽
function c11112013.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112013,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,11112013)
	e1:SetCondition(c11112013.spcon)
	e1:SetTarget(c11112013.sptg)
	e1:SetOperation(c11112013.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112013,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,11112013)
	e2:SetCondition(c11112013.thcon)
	e2:SetTarget(c11112013.thtg)
	e2:SetOperation(c11112013.thop)
	c:RegisterEffect(e2)
end
function c11112013.filter(c,tp)
	return c:IsSetCard(0x15b) and c:IsReason(REASON_DESTROY)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c11112013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11112013.filter,1,nil,tp)
end
function c11112013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11112013.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(tp,2,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	   e1:SetRange(LOCATION_MZONE)
	   e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	   e1:SetCountLimit(1)
	   e1:SetValue(c11112013.valcon)
	   e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
	   c:RegisterEffect(e1)
	end
end	
function c11112013.valcon(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		e:GetHandler():RegisterFlagEffect(11112013,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)
		return true
	else return false end
end	
function c11112013.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end	
function c11112013.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c11112013.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end	
function c11112013.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()==tp
end
function c11112013.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:GetFlagEffectLabel(11112013)==e:GetLabel() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end