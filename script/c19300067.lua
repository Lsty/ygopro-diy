--镜现诗·表情丰富的扑克脸
function c19300067.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c19300067.ovfilter,aux.Stringid(19300067,0),3,c19300067.xyzop)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c19300067.sptg)
	e1:SetOperation(c19300067.spop)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetCondition(c19300067.descon)
	c:RegisterEffect(e2)
end
function c19300067.ovfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x193) and c:GetRank()==4 and c:IsType(TYPE_XYZ)
end
function c19300067.xyzop(e,tp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(19300067,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c19300067.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	local b1=e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	local b2=e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST)
	local b3=e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and b1 end
	if b3 then
		local opt=Duel.SelectOption(tp,aux.Stringid(19300067,1),aux.Stringid(19300067,2),aux.Stringid(19300067,3))
		e:SetLabel(opt)
		e:GetHandler():RemoveOverlayCard(tp,opt+1,opt+1,REASON_COST)
	elseif b2 then
		local opt=Duel.SelectOption(tp,aux.Stringid(19300067,1),aux.Stringid(19300067,2))
		e:SetLabel(opt)
		e:GetHandler():RemoveOverlayCard(tp,opt+1,opt+1,REASON_COST)
	elseif b1 then
		Duel.SelectOption(tp,aux.Stringid(19300067,1))
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
		e:SetLabel(0)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c19300067.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==0 then
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	elseif e:GetLabel()==1 then
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE)
		end
	elseif e:GetLabel()==2 then
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function c19300067.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(19300067)~=0
end