--Lunar Phase Beast: Tiny Pony Moon Burst
function c4242564.initial_effect(c)
 --pendulum summon
 aux.EnablePendulumAttribute(c)
 --atk
 local e1=Effect.CreateEffect(c)
 e1:SetType(EFFECT_TYPE_FIELD)
 e1:SetCode(EFFECT_UPDATE_ATTACK)
 e1:SetRange(LOCATION_PZONE)
 e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
 e1:SetTarget(c4242564.efilter)
 e1:SetValue(300)
 c:RegisterEffect(e1)
 --Def 
 local e2=e1:Clone()
 e2:SetCode(EFFECT_UPDATE_DEFENSE)
 e2:SetValue(300)
 c:RegisterEffect(e2)
 --spsummon proc
 local e3=Effect.CreateEffect(c)
 e3:SetDescription(aux.Stringid(4242564,2))
 e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
 e3:SetType(EFFECT_TYPE_IGNITION)
 e3:SetRange(LOCATION_PZONE)
 e3:SetCondition(c4242564.condition)
 e3:SetTarget(c4242564.target)
 e3:SetOperation(c4242564.operation)
 c:RegisterEffect(e3)
 --death into scale
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4242564,3))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c4242564.pencon)
	e4:SetTarget(c4242564.pentg)
	e4:SetOperation(c4242564.penop)
	c:RegisterEffect(e4)
		--draw/replace
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(4242564,4))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCondition(c4242564.condition2)
	e5:SetTarget(c4242564.target2)
	e5:SetOperation(c4242564.operation2)
	c:RegisterEffect(e5)
	--sp summon 
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(4242564,5))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c4242564.condition3)
	e6:SetTarget(c4242564.target3)
	e6:SetOperation(c4242564.operation3)
	c:RegisterEffect(e6)
end
function c4242564.efilter(e,c)
 return c:IsSetCard(0x666)
end
function c4242564.condition(e,tp,eg,ep,ev,re,r,rp)
 return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c4242564.target(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c4242564.operation(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
 if not c:IsRelateToEffect(e) then return end
 if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
  Duel.SendtoGrave(c,REASON_RULE)
 end
end
function c4242564.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c4242564.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c4242564.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c4242564.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
	end
	function c4242564.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c4242564.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then
	Duel.Destroy(c,REASON_EFFECT)
	
	end
end
function c4242564.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c4242564.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and not c:IsLevelBelow(3) and (c:IsSetCard(0x666)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c4242564.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242564.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c4242564.operation3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4242564.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end