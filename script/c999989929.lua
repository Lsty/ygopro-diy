--圣者的招引
function c999989929.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(114000328,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,999989929+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c999989929.dcd)
	e1:SetTarget(c999989929.dtg)
	e1:SetOperation(c999989929.dop)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(114000328,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,999989929+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c999989929.lcd)
	e2:SetCost(c999989929.lcost)
	e2:SetTarget(c999989929.ltg)
	e2:SetOperation(c999989929.lop)
	c:RegisterEffect(e2)
	if not c999989929.global_check then
		c999989929.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c999989929.checkop)
		Duel.RegisterEffect(ge1,0)
end
end
function c999989929.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p1=nil
	local p2=nil
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsAttribute(ATTRIBUTE_LIGHT) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,999989929,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,999989929,RESET_PHASE+PHASE_END,0,1) end
end
function c999989929.dcd(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local tc=g:GetFirst()
	return g:GetCount()==1 and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_DARK)
end
function c999989929.filter(c,e,tp)
	return  c:IsAttribute(ATTRIBUTE_DARK) and not c:IsType(TYPE_TOKEN) and Duel.IsExistingMatchingCard(c999989929.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c999989929.filter2(c,e,tp)
    return  c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ) and (c:IsSetCard(0x984) or c:IsSetCard(0x985)) 
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c999989929.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c999989929.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c999989929.filter,tp,LOCATION_MZONE,0,1,nil,e,tp)
    and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c999989929.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c999989929.dop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999989929.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_FIELD)
    	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	    e1:SetTargetRange(1,0)
	    e1:SetTarget(c999989929.splimit)
	    e1:SetReset(RESET_PHASE+PHASE_END)
	    Duel.RegisterEffect(e1,tp)
end
end
function c999989929.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c999989929.lcd(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c999989929.lcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,999989929)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c999989929.splimit2)
	Duel.RegisterEffect(e1,tp)
end
function c999989929.splimit2(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsAttribute(0xff-ATTRIBUTE_LIGHT)
end
function c999989929.filter3(c,e,tp)
	return  (c:IsSetCard(0x984) or c:IsSetCard(0x985)) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999989929.ltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c999989929.filter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c999989929.lop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999989929.filter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end