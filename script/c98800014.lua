--黑圆桌第九位 Eleonore Von Wittenburg
function c98800014.initial_effect(c)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c98800014.sumlimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_NAGA+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c98800014.spcon)
	e2:SetTarget(c98800014.sptg)
	e2:SetOperation(c98800014.spop)
	c:RegisterEffect(e2)
	--cannot remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	c:RegisterEffect(e3)
end
function c98800014.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_GRAVE)
end
function c98800014.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ((e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and (e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) or e:GetHandler():IsPreviousLocation(LOCATION_REMOVED))) or e:GetHandler():IsPreviousLocation(LOCATION_GRAVE))
		and e:GetHandler():IsReason(REASON_EFFECT)
end
function c98800014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetControler()~=tp and chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c98800014.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end