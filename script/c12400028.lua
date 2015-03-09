--万能卡片
function c12400028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12400028.target)
	e1:SetOperation(c12400028.activate)
	c:RegisterEffect(e1)
end
function c12400028.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c12400028.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12400028.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12400028.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c12400028.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local opt=Duel.SelectOption(tp,aux.Stringid(12400028,0),aux.Stringid(12400028,1),aux.Stringid(12400028,2))
	e:SetLabel(opt)
end
function c12400028.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if e:GetLabel()==2 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e2:SetValue(c12400028.efilter)
			e2:SetLabel(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e3:SetValue(c12400028.efilter)
			e3:SetLabel(TYPE_EFFECT)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		else
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(c12400028.efilter)
			if e:GetLabel()==0 then
				e4:SetLabel(TYPE_SPELL)
			else e4:SetLabel(TYPE_TRAP) end
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
	end
end
function c12400028.efilter(e,te)
	return te:IsActiveType(e:GetLabel())
end
