--The Disgraced Angel 
function c59821077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c59821077.condition)
	e1:SetTarget(c59821077.target)
	e1:SetOperation(c59821077.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821077,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c59821077.spcon)
	e2:SetTarget(c59821077.sptg)
	e2:SetOperation(c59821077.spop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(59821077,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCondition(c59821077.drcon)
	e3:SetTarget(c59821077.drtg)
	e3:SetOperation(c59821077.drop)
	c:RegisterEffect(e3)
end
function c59821077.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c59821077.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsDestructable()
end
function c59821077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c59821077.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
	Duel.SetChainLimit(aux.FALSE)
end
function c59821077.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821077.filter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function c59821077.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c59821077.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,59821077,0,0x11,4,1200,2000,RACE_FAIRY,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c59821077.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,59821077,0,0x11,4,1200,2000,RACE_FAIRY,ATTRIBUTE_DARK) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x47e0000)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2,true)
	end
end
function c59821077.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821077.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c59821077.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end