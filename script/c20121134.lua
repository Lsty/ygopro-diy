--骨芽
function c20121134.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c20121134.xyzfilter,8,2)
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c20121134.reptg)
	e1:SetValue(c20121134.repval)
	c:RegisterEffect(e1)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(c20121134.aclimit)
	e4:SetCondition(c20121134.dscon)
	c:RegisterEffect(e4)
end
function c20121134.xyzfilter(c)
	return c:IsRace(RACE_WARRIOR)
end
function c20121134.repfilter(c,tp)
	return c:IsOnField() and c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_WARRIOR)
end
function c20121134.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c20121134.repfilter,1,nil,tp) end
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(20121134,0)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		local g=eg:Filter(c20121134.repfilter,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		return true
	else return false end
end
function c20121134.repval(e,c)
	return c==e:GetLabelObject()
end
function c20121134.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_GRAVE and re:IsActiveType(TYPE_MONSTER)
end
function c20121134.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end