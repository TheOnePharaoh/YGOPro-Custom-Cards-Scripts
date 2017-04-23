--RUM－The Deity of Evil
function c59821088.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59821088,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c59821088.condition)
	e1:SetTarget(c59821088.target1)
	e1:SetOperation(c59821088.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821088,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c59821088.condition)
	e2:SetTarget(c59821088.target2)
	e2:SetOperation(c59821088.activate2)
	c:RegisterEffect(e2)
	--add setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0x95)
	c:RegisterEffect(e3)
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e4:SetCondition(c59821088.handcon)
	c:RegisterEffect(e4)
end
function c59821088.handcon(e)
	return tp~=Duel.GetTurnPlayer()
end
function c59821088.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0xa1a2) and tc:IsType(TYPE_XYZ)
end
function c59821088.filter11(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xa1a2) and c:IsRankBelow(4)
		and Duel.IsExistingMatchingCard(c59821088.filter21,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1,c:GetAttribute(),c:GetCode())
end
function c59821088.filter21(c,e,tp,mc,rk,att,code)
	return c:GetRank()==rk and c:IsAttribute(att) and (c:IsSetCard(0xa1a2)) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c59821088.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c59821088.filter11(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c59821088.filter11,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c59821088.filter11,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c59821088.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c59821088.filter21,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,tc:GetAttribute(),tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		if Duel.GetOverlayCount(tp,0,1)~=0 then
			Duel.BreakEffect()
			local g1=Duel.GetOverlayGroup(tp,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(59821088,1))
			local mg2=g1:Select(tp,1,1,nil)
			local oc=mg2:GetFirst():GetOverlayTarget()
			Duel.Overlay(sc,mg2)
			Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		end
	end
end
function c59821088.filter12(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xa1a2) and c:IsRankAbove(5)
		and Duel.IsExistingMatchingCard(c59821088.filter22,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk-1,c:GetAttribute(),c:GetCode())
end
function c59821088.filter22(c,e,tp,mc,rk,att,code)
	return c:GetRank()==rk and c:IsAttribute(att) and (c:IsSetCard(0xa1a2)) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c59821088.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c59821088.filter12(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c59821088.filter12,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c59821088.filter12,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c59821088.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c59821088.filter22,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()-1,tc:GetAttribute(),tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		if Duel.GetOverlayCount(tp,0,1)~=0 then
			Duel.BreakEffect()
			local g1=Duel.GetOverlayGroup(tp,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(59821088,1))
			local mg2=g1:Select(tp,1,1,nil)
			local oc=mg2:GetFirst():GetOverlayTarget()
			Duel.Overlay(sc,mg2)
			Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		end
	end
end