--Vocaloid Hiyama Kiyoteru
function c29732404.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c29732404.condition)
	e1:SetTarget(c29732404.target)
	e1:SetOperation(c29732404.activate)
	c:RegisterEffect(e1)
end
function c29732404.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c29732404.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,29732404,0,0x11,800,2500,5,RACE_MACHINE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29732404.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,29732404,0,0x11,800,2500,5,RACE_MACHINE,ATTRIBUTE_LIGHT) then return end
	c:AddTrapMonsterAttribute(TYPE_TUNER,ATTRIBUTE_LIGHT,RACE_MACHINE,5,800,2500)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	c:TrapMonsterBlock()
end
