--夜夜 禁忌之月
function c1314529.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c1314529.fuscon)
	e1:SetOperation(c1314529.fusop)
	c:RegisterEffect(e1)
	--unaffectable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c1314529.imval)
	c:RegisterEffect(e2)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1314529,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c1314529.rmtg)
	e4:SetOperation(c1314529.rmop)
	c:RegisterEffect(e4)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1314529,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,1314529)
	e4:SetCost(c1314529.spcost)
	e4:SetTarget(c1314529.sptg)
	e4:SetOperation(c1314529.spop)
	c:RegisterEffect(e4)
end
c1314529.material_count=2
function c1314529.material(c)
	return c:IsType(0x1) and c:IsSetCard(0x9fd) and c:IsAbleToRemove() and c:IsType(TYPE_RITUAL)
end
function c1314529.fuscon(e,g,gc,chkf)
	if g==nil then return false end
	local mg=g:Filter(c1314529.material,nil)
	if gc and not gc:IsSetCard(0x9fd)  then return false end
	if chkf~=PLAYER_NONE and not mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then return false end
	return mg:GetCount()>=2 
end 
function c1314529.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local ag=Group.CreateGroup()
	local mg=eg:Filter(c1314529.material,nil)
	if mg:GetCount()==0 then return end
	local ct=1
	if gc and gc:IsSetCard(0x9fd) then ct=2 end
	   for i=ct , 2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		if i==1 and chkf~=PLAYER_NONE then
			tc=mg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf):GetFirst()
			else tc=mg:Select(tp,1,1,nil):GetFirst() end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESET_CHAIN)
			e1:SetValue(0x20)
			tc:RegisterEffect(e1,true)
			ag:AddCard(tc)
			mg:RemoveCard(tc)
		end 
	Duel.SetFusionMaterial(ag)	
end  
function c1314529.imval(e,te)
	if not te:IsActiveType(0x1) then return false end
	return not te:GetHandler():IsAttribute(0xa)
end   
function c1314529.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,0xe)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0xe)
end
function c1314529.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,0xe,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,0x400)
	end
end
function c1314529.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c1314529.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x9fd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_RITUAL)
end
function c1314529.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1314529.filter1,tp,LOCATION_REMOVED,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c1314529.filter1,tp,LOCATION_REMOVED,0,2,2,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function c1314529.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	if g:GetCount()<=ft then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end