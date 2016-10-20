--Dreadnought Mark - 002 Desert Storm
function c22769902.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22769902,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22769902.condition)
	e1:SetTarget(c22769902.target)
	e1:SetOperation(c22769902.operation)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22769902,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c22769902.spcon)
	e2:SetTarget(c22769902.sptg)
	e2:SetOperation(c22769902.spop)
	c:RegisterEffect(e2)
	--cannot be effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c22769902.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsFaceup() and at:IsControler(tp) and at:GetLevel()==10 and at:IsRace(RACE_MACHINE)
end
function c22769902.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22769902.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c22769902.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c22769902.mfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_TOKEN+TYPE_XYZ)
end
function c22769902.xyzfilter(c,mg)
	return c:IsSetCard(0xaa14) and c:IsXyzSummonable(mg)
end
function c22769902.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c22769902.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c22769902.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22769902.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22769902.mfilter,tp,LOCATION_MZONE,0,nil)
	local xyzg=Duel.GetMatchingGroup(c22769902.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:FilterSelect(tp,xyz.xyz_filter,xyz.xyz_count,xyz.xyz_count,nil)
		Duel.XyzSummon(tp,xyz,sg)
	end
end
