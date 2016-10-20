--Mystical Illusion
function c89990016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c89990016.condition)
	e1:SetTarget(c89990016.target)
	e1:SetOperation(c89990016.activate)
	c:RegisterEffect(e1)
end
function c89990016.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsPosition(POS_FACEUP)
end
function c89990016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,89990016,0,0x11,a:GetBaseAttack(),a:GetBaseDefense(),
		a:GetOriginalLevel(),RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c89990016.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local a=Duel.GetAttacker()
	if not a or a:IsFacedown() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,89990016,0,0x11,a:GetBaseAttack(),a:GetBaseDefense(),
		a:GetOriginalLevel(),RACE_WARRIOR,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	c:AddMonsterAttributeComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetValue(tc:GetBaseDefense())
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(tc:GetBaseAttack())
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(tc:GetOriginalLevel())
	c:RegisterEffect(e3)
	Duel.ChangeAttackTarget(c)
end
