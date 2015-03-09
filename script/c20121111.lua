--赤光黑卍字遮华
function c20121111.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c20121111.spcon)
	e1:SetTarget(c20121111.sptg)
	e1:SetOperation(c20121111.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c20121111.thcon)
	e2:SetTarget(c20121111.thtg)
	e2:SetOperation(c20121111.thop)
	c:RegisterEffect(e2)
end
function c20121111.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsControler(tp) and ec:IsAttribute(ATTRIBUTE_DARK)
end
function c20121111.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20121111)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.RegisterFlagEffect(tp,20121111,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c20121111.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c20121111.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c20121111.filter1(c)
	return c:IsAbleToRemove()
end
function c20121111.filter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c20121111.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local b1=Duel.IsExistingTarget(c20121111.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local b2=Duel.IsExistingTarget(c20121111.filter2,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return true end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(20121111,0),aux.Stringid(20121111,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(20121111,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(20121111,1))+1
	else op=3 end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,c20121111.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	elseif op~=3 and op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local g=Duel.SelectTarget(tp,c20121111.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function c20121111.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	elseif e:GetLabel()~=3 and e:GetLabel()~=0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end